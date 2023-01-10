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

public class ExampleBase: _ExampleBase {
    /// The example name.
    var name: String

    /**
        The site at which the example is defined.
        This must be set correctly in order for Xcode to highlight
        the correct line in red when reporting a failure.
    */
    public var callsite: Callsite

    internal init(name: String, callsite: Callsite) {
        self.name = name
        self.callsite = callsite
    }

    internal func handleThrownErrorFromTest(error: Error) {
        if let stopTestError = error as? StopTest {
            self.reportStoppedTest(stopTestError)
        } else if let testSkippedError = error as? XCTSkip {
            self.reportSkippedTest(testSkippedError, name: name, callsite: callsite)
        } else {
            self.reportFailedTest(error, name: name, callsite: callsite)
        }
    }

#if canImport(Darwin)
    static internal let recordSkipSelector = NSSelectorFromString("recordSkipWithDescription:sourceCodeContext:")
#endif

    internal func reportSkippedTest(_ testSkippedError: XCTSkip, name: String, callsite: Callsite) {
        #if !canImport(Darwin)
            return // This functionality is only supported by Apple's proprietary XCTest, not by swift-corelibs-xctest
        #else // `NSSelectorFromString` requires the Objective-C runtime, which is not available on Linux.

            let messageSuffix = """
                \n
                If nobody else has done so yet, please submit an issue to https://github.com/Quick/Quick/issues

                For now, we'll just benignly ignore skipped tests.
            """

            guard let testRun = currentSpec.testRun else {
                print("""
                     [Quick Warning]: `AsyncSpec.current.testRun` and `QuickSpec.current.testRun` were unexpectededly `nil`.
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
            currentSpec.record(issue)
        #else
            currentSpec.recordFailure(
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
            currentSpec.record(issue)
        #else
            currentSpec.recordFailure(
                withDescription: stopTestError.failureDescription,
                inFile: file,
                atLine: Int(callsite.line),
                expected: true
            )
        #endif
    }

    private var currentSpec: XCTestCase {
        AsyncSpec.current ?? QuickSpec.current
    }
}
