#if canImport(Darwin)
import Foundation

/**
 Responsible for building a "Selected tests" suite. This corresponds to a single
 spec, and all its examples.
 */
internal class QuickSelectedTestSuiteBuilder: QuickTestSuiteBuilder {

    /**
     The test spec class to run.
     */
    let testCaseClass: AnyClass!

    /**
     The test name to filter by, if there is one.
     */
    let testName: String?

    /**
     For Objective-C classes, returns the class name. For Swift classes without,
     an explicit Objective-C name, returns a module-namespaced class name
     (e.g., "FooTests.FooSpec").
     */
    var testSuiteClassName: String {
        return NSStringFromClass(testCaseClass)
    }

    /**
     Given a test case name:

        FooSpec/testFoo

     Optionally constructs a test suite builder for the named test case class
     in the running test bundle.

     If no test bundle can be found, or the test case class can't be found,
     initialization fails and returns `nil`.
     */
    init?(forTestCaseWithName name: String, testName: String?) {
        guard let testCaseClass = testCaseClassForTestCaseWithName(name) else {
            self.testCaseClass = nil
            return nil
        }

        self.testCaseClass = testCaseClass
        self.testName = testNameForTestCaseName(name, testName: testName)
    }

    /**
     Returns a `QuickTestSuite` that runs the associated test case class.
     */
    func buildTestSuite() -> QuickTestSuite {
        let suite = QuickTestSuite(forTestCaseClass: testCaseClass)

        if let testName = testName {
            let filteredSuite = QuickTestSuite(name: suite.name)
            // test names are in the format "-[ClassName testName]"
            for test in suite.tests.filter({ $0.name == testName }) {
                filteredSuite.addTest(test)
            }
            return filteredSuite
        } else {
            return suite
        }
    }
}

/**
 Searches `Bundle.allBundles()` for an xctest bundle, then looks up the named
 test case class in that bundle.

 Returns `nil` if a bundle or test case class cannot be found.
 */
private func testCaseClassForTestCaseWithName(_ name: String) -> AnyClass? {
    guard let bundle = Bundle.currentTestBundle else { return nil }

    if let testCaseClass = bundle.classNamed(name) { return testCaseClass }

    let moduleName = bundle.moduleName

    return NSClassFromString("\(moduleName).\(name)")
}

private func testNameForTestCaseName(_ testCaseName: String, testName: String?) -> String? {
    guard let testName = testName else { return nil }
    return "-[\(testCaseName) \(testName)]"
}

#endif
