#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)

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
    init?(forTestCaseWithName name: String) {
        guard let testCaseClass = testCaseClassForTestCaseWithName(name) else {
            self.testCaseClass = nil
            return nil
        }

        self.testCaseClass = testCaseClass
    }

    /**
     Returns a `QuickTestSuite` that runs the associated test case class.
     */
    func buildTestSuite() -> QuickTestSuite {
        return QuickTestSuite(forTestCaseClass: testCaseClass)
    }

}

/**
 Searches `NSBundle.allBundles()` for an xctest bundle, then looks up the named
 test case class in that bundle.

 Returns `nil` if a bundle or test case class cannot be found.
 */
private func testCaseClassForTestCaseWithName(name: String) -> AnyClass? {
    func extractClassName(name: String) -> String? {
        return name.characters.split("/").first.map(String.init)
    }

    guard let className = extractClassName(name) else { return nil }
    guard let bundle = NSBundle.currentTestBundle else { return nil }

    if let testCaseClass = bundle.classNamed(className) { return testCaseClass }

    guard let moduleName = bundle.bundlePath.fileName else { return nil }

    return NSClassFromString("\(moduleName).\(className)")
}

#endif
