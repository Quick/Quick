internal class QuickSelectedTestSuite: QuickTestSuite, QuickTestSuiteBuilder {

    let testCaseClass: AnyClass!

    private static var builtTestSuites: Set<String> = Set()

    private static func className(fromTestCaseWithName name: String) -> String? {
        return name.characters.split("/").first.map(String.init)
    }

    private static func testCaseClass(forTestCaseWithName name: String) -> AnyClass? {
        guard let className = className(fromTestCaseWithName: name) else { return nil }
        guard let bundle = NSBundle.currentTestBundle else { return nil }

        if let testCaseClass = bundle.classNamed(className) {
            return testCaseClass
        }

        guard let moduleName = bundle.bundlePath.fileName else { return nil }

        return NSClassFromString("\(moduleName).\(className)")
    }

    // TODO: Move the tracking of "built test suites" up into `QuickTestSuite.selectedTestSuite(forTestCaseWithName:)`.
    init?(forTestCaseWithName name: String) {
        guard let testCaseClass = QuickSelectedTestSuite.testCaseClass(forTestCaseWithName: name) else {
            self.testCaseClass = nil
            super.init()
            return nil
        }

        self.testCaseClass = testCaseClass

        let namespacedClassName = NSStringFromClass(testCaseClass)

        guard !QuickSelectedTestSuite.builtTestSuites.contains(namespacedClassName) else {
            super.init()
            return nil
        }

        QuickSelectedTestSuite.builtTestSuites.insert(namespacedClassName)

        super.init(name: String(testCaseClass))
    }

    func buildTestSuite() -> QuickTestSuite {
        for invocation in testCaseClass.testInvocations() {
            let testCase = (testCaseClass as AnyObject).performSelector("testCaseWithInvocation:", withObject: invocation)
            if let testCase = testCase.takeUnretainedValue() as? XCTestCase {
                addTest(testCase)
            }
        }
        return self
    }

}
