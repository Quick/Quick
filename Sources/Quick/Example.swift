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

/**
    Examples, defined with the `it` function, use assertions to
    demonstrate how code should behave. These are like "tests" in XCTest.
*/
final public class Example: _ExampleBase {
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
    private let closure: () throws -> Void
    private let flags: FilterFlags

    internal init(description: String, callsite: Callsite, flags: FilterFlags, closure: @escaping () throws -> Void) {
        self.internalDescription = description
        self.closure = closure
        self.callsite = callsite
        self.flags = flags
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

    /**
        Executes the example closure, as well as all before and after
        closures defined in the its surrounding example groups.
    */
    public func run() {
        let world = World.sharedWorld

        if world.numberOfExamplesRun == 0 {
            world.suiteHooks.executeBefores()
        }

        let exampleMetadata = ExampleMetadata(example: self, exampleIndex: world.numberOfExamplesRun)
        world.currentExampleMetadata = exampleMetadata
        defer {
            world.currentExampleMetadata = nil
        }

        group!.phase = .beforesExecuting

        let runExample = { [closure, name, callsite] in
            self.group!.phase = .beforesFinished

            do {
                try closure()
            } catch {
                if let testSkippedError = error as? XCTSkip {
                    self.reportSkippedTest(testSkippedError, name: name, callsite: callsite)
                } else {
                    self.reportFailedTest(error, name: name, callsite: callsite)
                }
            }

            self.group!.phase = .aftersExecuting
        }

        let allWrappers = group!.wrappers + world.exampleHooks.wrappers
        let wrappedExample = allWrappers.reduce(runExample) { closure, wrapper in
            return { wrapper(exampleMetadata, closure) }
        }
        wrappedExample()

        group!.phase = .aftersFinished

        world.numberOfExamplesRun += 1

        if !world.isRunningAdditionalSuites && world.numberOfExamplesRun >= world.cachedIncludedExampleCount {
            world.suiteHooks.executeAfters()
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
    static let recordSkipSelector = NSSelectorFromString("recordSkipWithDescription:sourceCodeContext:")
    #endif

    private func reportSkippedTest(_ testSkippedError: XCTSkip, name: String, callsite: Callsite) { // swiftlint:disable:this function_body_length
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

            if isLegacyXcode(testRun: testRun) {
                reportSkippedTest_legacy(testRun: testRun, skippedTestContext: skippedTestContext)
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

    #if canImport(Darwin)
    private func isLegacyXcode(testRun: XCTestRun) -> Bool {
        !testRun.responds(to: Self.recordSkipSelector)
    }

    /// Attempt to report a test skip for old Xcode versions (namely Xcode 12.4).
    ///
    /// As of Xcode 12.4, the `XCTSkippedTestContext` object contained these fields:
    /// - `filePath: NSString`
    /// - `lineNumber: NSString`
    ///
    /// After Xcode 12.4, those fields were extracted into a new `sourceCodeContext: XCTSkippedTestContext` property.
    /// - Parameters:
    ///   - testRun: The test run that was skipped
    ///   - skippedTestContext: an `XCTSkippedTestContext` object
    private func reportSkippedTest_legacy(testRun: XCTestRun, skippedTestContext: NSObject) {
        let legacyRecordSkipSelector = NSSelectorFromString("recordSkipWithDescription:inFile:atLine:")

        guard let imp = testRun.method(for: legacyRecordSkipSelector),
              let description = skippedTestContext.value(forKey: "message") as? NSString,
              let filePath = skippedTestContext.value(forKey: "filePath") as? NSString,
              let lineNumber = skippedTestContext.value(forKey: "lineNumber") as? UInt32 else {
            return
        }

        typealias MethodSigniture = @convention(c) (NSObject, Selector, NSString, NSString, UInt32) -> Void

        let methodImp = unsafeBitCast(imp, to: MethodSigniture.self)

        methodImp(
            /* self */ testRun,
            /* selector */ legacyRecordSkipSelector,
            /* recordSkipWithDescription: */ description,
            /* inFile: */ filePath,
            /* atLine: */ lineNumber
        )
    }
    #endif

    private func reportFailedTest(_ error: Error, name: String, callsite: Callsite) {
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
