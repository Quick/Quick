import Foundation
import XCTest

#if canImport(Darwin)
// swiftlint:disable type_name
@objcMembers
public class _ExampleBase: NSObject {}
#else
public class _ExampleBase: NSObject {}
// swiftlint:enable type_name
#endif

public class Example: _ExampleBase {
    /**
        A boolean indicating whether the example is a shared example;
        i.e.: whether it is an example defined with `itBehavesLike`.
    */
    public var isSharedExample = false

    /**
        The site at which the example is defined.
        This must be set correctly in order for Xcode to highlight
        the correct line in red when reporting a failure.
    */
    public var callsite: Callsite

    weak internal var group: ExampleGroup?

    private let internalDescription: String
    private let flags: FilterFlags
    private let closure: () async throws -> Void

    internal init(description: String, callsite: Callsite, flags: FilterFlags, closure: @escaping () async throws -> Void) {
        self.internalDescription = description
        self.callsite = callsite
        self.flags = flags
        self.closure = closure
    }

    public override var description: String {
        return internalDescription
    }

    /**
        The example name. A name is a concatenation of the name of
        the example group the example belongs to, followed by the
        description of the example itself.

        The example name is used to generate a test method selector
        to be displayed in Xcode's test navigator.
    */
    public var name: String {
        guard let groupName = group?.name else { return description }
        return "\(groupName), \(description)"
    }

    public func run() async {
        let world = World.sharedWorld

        if world.numberOfExamplesRun == 0 {
            await world.suiteHooks.executeBefores()
        }

        let exampleMetadata = ExampleMetadata(example: self, exampleIndex: world.numberOfExamplesRun)
        world.currentExampleMetadata = exampleMetadata
        defer {
            world.currentExampleMetadata = nil
        }

        group!.phase = .beforesExecuting

        let runExample: () async -> Void = { [closure, name, callsite] in
            self.group!.phase = .beforesFinished

            do {
                try await closure()
            } catch {
                if let stopTestError = error as? StopTest {
                    self.reportStoppedTest(stopTestError)
                } else if let testSkippedError = error as? XCTSkip {
                    self.reportSkippedTest(testSkippedError, name: name, callsite: callsite)
                } else {
                    self.reportFailedTest(error, name: name, callsite: callsite)
                }
            }

            self.group!.phase = .aftersExecuting
        }

        let allJustBeforeEachStatements = group!.justBeforeEachStatements + world.exampleHooks.justBeforeEachStatements
        let justBeforeEachExample = allJustBeforeEachStatements.reduce(runExample) { closure, wrapper in
            return { await wrapper(exampleMetadata, closure) }
        }

        let allWrappers = group!.wrappers + world.exampleHooks.wrappers
        let wrappedExample = allWrappers.reduce(justBeforeEachExample) { closure, wrapper in
            return { await wrapper(exampleMetadata, closure) }
        }
        await wrappedExample()

        group!.phase = .aftersFinished

        world.numberOfExamplesRun += 1

        if !world.isRunningAdditionalSuites && world.numberOfExamplesRun >= world.cachedIncludedExampleCount {
            await world.suiteHooks.executeAfters()
        }
    }

    /**
        Evaluates the filter flags set on this example and on the example groups
        this example belongs to. Flags set on the example are trumped by flags on
        the example group it belongs to. Flags on inner example groups are trumped
        by flags on outer example groups.
    */
    internal var filterFlags: FilterFlags {
        var aggregateFlags = flags
        for (key, value) in group!.filterFlags {
            aggregateFlags[key] = value
        }
        return aggregateFlags
    }

    #if canImport(Darwin)
    static internal let recordSkipSelector = NSSelectorFromString("recordSkipWithDescription:sourceCodeContext:")
    #endif

    internal func reportSkippedTest(_ testSkippedError: XCTSkip, name: String, callsite: Callsite) { // swiftlint:disable:this function_body_length
        #if !canImport(Darwin)
            return // This functionality is only supported by Apple's proprietary XCTest, not by swift-corelibs-xctest
        #else // `NSSelectorFromString` requires the Objective-C runtime, which is not available on Linux.

            let messageSuffix = """
                \n
                If nobody else has done so yet, please submit an issue to https://github.com/Quick/Quick/issues

                For now, we'll just benignly ignore skipped tests.
            """

            guard let testRun = QuickSpec.current.testRun else {
                print("""
                     [Quick Warning]: `QuickSpec.current.testRun` was unexpectededly `nil`.
                """ + messageSuffix)
                return
            }

            guard let skippedTestContextAny = testSkippedError.errorUserInfo["XCTestErrorUserInfoKeySkippedTestContext"] else {
                print("""
                [Quick Warning]: The internals of Apple's XCTestCaseRun have changed.
                    We expected the `errorUserInfo` dictionary of the XCTSKip error to contain a value for the key
                    "XCTestErrorUserInfoKeySkippedTestContext", but it didn't.
                """ + messageSuffix)
                return
            }

            // Uses an internal type "XCTSkippedTestContext", but "NSObject" will be sufficient for `perform(_:with:_with:)`.
            guard let skippedTestContext = skippedTestContextAny as? NSObject else {
                print("""
                [Quick Warning]: The internals of Apple's XCTestCaseRun have changed.
                    We expected `skippedTestContextAny` to have type `NSObject`,
                    but we got an object of type \(type(of: skippedTestContextAny))
                """ + messageSuffix)
                return
            }

            guard let sourceCodeContextAny = skippedTestContext.value(forKey: "sourceCodeContext") else {
                print("""
                [Quick Warning]: The internals of Apple's XCTestCaseRun have changed.
                    We expected `XCTSkippedTestContext` to have a `sourceCodeContext` property, but it did not.
                """ + messageSuffix)
                return
            }

            guard let sourceCodeContext = sourceCodeContextAny as? XCTSourceCodeContext else {
                print("""
                    [Quick Warning]: The internals of Apple's XCTestCaseRun have changed.
                    We expected `XCTSkippedTestContext.sourceCodeContext` to have type `XCTSourceCodeContext`,
                    but we got an object of type \(type(of: sourceCodeContextAny)).
                """ + messageSuffix)
                return
            }

            guard testRun.responds(to: Self.recordSkipSelector) else {
                print("""
                [Quick Warning]: The internals of Apple's XCTestCaseRun have changed, as it no longer responds to
                    the -[XCTSkip \(NSStringFromSelector(Self.recordSkipSelector))] message necessary to report skipped tests to Xcode.
                """ + messageSuffix)
               return
            }

            testRun.perform(Self.recordSkipSelector, with: testSkippedError.message, with: sourceCodeContext)
        #endif
    }

    internal func reportFailedTest(_ error: Error, name: String, callsite: Callsite) {
        let description = "Test \(name) threw unexpected error: \(error.localizedDescription)"

        #if SWIFT_PACKAGE
            let file = callsite.file.description
        #else
            let file = callsite.file
        #endif

        #if !SWIFT_PACKAGE
            let location = XCTSourceCodeLocation(filePath: file, lineNumber: Int(callsite.line))
            let sourceCodeContext = XCTSourceCodeContext(location: location)
            let issue = XCTIssue(
                type: .thrownError,
                compactDescription: description,
                sourceCodeContext: sourceCodeContext
            )
            QuickSpec.current.record(issue)
        #else
            QuickSpec.current.recordFailure(
                withDescription: description,
                inFile: file,
                atLine: Int(callsite.line),
                expected: false
            )
        #endif
    }

    internal func reportStoppedTest(_ stopTestError: StopTest) {
        guard stopTestError.reportError else { return }

        let callsite = stopTestError.callsite

        #if SWIFT_PACKAGE
            let file = callsite.file.description
        #else
            let file = callsite.file
        #endif

        #if !SWIFT_PACKAGE
            let location = XCTSourceCodeLocation(filePath: file, lineNumber: Int(callsite.line))
            let sourceCodeContext = XCTSourceCodeContext(location: location)
            let issue = XCTIssue(
                type: .assertionFailure,
                compactDescription: stopTestError.failureDescription,
                sourceCodeContext: sourceCodeContext
            )
            QuickSpec.current.record(issue)
        #else
            QuickSpec.current.recordFailure(
                withDescription: stopTestError.failureDescription,
                inFile: file,
                atLine: Int(callsite.line),
                expected: true
            )
        #endif
    }
}

extension Example {
    /**
        Returns a boolean indicating whether two Example objects are equal.
        If two examples are defined at the exact same callsite, they must be equal.
    */
    @nonobjc public static func == (lhs: Example, rhs: Example) -> Bool {
        return lhs.callsite == rhs.callsite
    }
}
