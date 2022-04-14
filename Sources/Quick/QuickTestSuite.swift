#if canImport(Darwin)

import XCTest

/**
 This protocol defines the role of an object that builds test suites.
 */
internal protocol QuickTestSuiteBuilder {

    /**
     Construct a `QuickTestSuite` instance with the appropriate test cases added as tests.

     Subsequent calls to this method should return equivalent test suites.
     */
    func buildTestSuite() -> QuickTestSuite

}

/**
 A base class for a class cluster of Quick test suites, that should correctly
 build dynamic test suites for XCTest to execute.
 */
public class QuickTestSuite: XCTestSuite {
    /** Resets the built test suites

        Exposed for testing reasons only.
     */
    @objc
    internal static func reset() {
        builtTestSuites = []
    }

    private static var builtTestSuites: Set<String> = Set()

    /**
     Construct a test suite for a specific, selected subset of tests and test cases (rather
     than the default, which as all test cases).

     If this method is called multiple times for the same test case class, e.g..

        FooSpec, testBar
        FooSpec, testBar

     It is expected that the first call should return a valid test suite, and
     all subsequent calls should return `nil`.

     - Parameter name: The name of the `XCTastCase`/`QuickSpec` subclass.
     - Parameter testName: The name of the individual test to run (if specified).
     - Returns: A valid test case (if tests were added to the test suite to run), or nil (if tests were not added to the test suite to run)
     */
    @objc
    public static func selectedTestSuite(forTestCaseWithName name: String, testName: String?) -> QuickTestSuite? {
        guard let builder = QuickSelectedTestSuiteBuilder(forTestCaseWithName: name, testName: testName) else { return nil }

        let (inserted, _) = builtTestSuites.insert(builder.testSuiteClassName)
        if inserted {
            return builder.buildTestSuite()
        } else {
            return nil
        }
    }
}

#endif
