internal class QuickSelectedTestSuiteBuilder: QuickTestSuiteBuilder {

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
        guard let testCaseClass = QuickSelectedTestSuiteBuilder.testCaseClass(forTestCaseWithName: name) else {
            self.testCaseClass = nil
            return nil
        }

        self.testCaseClass = testCaseClass

        let namespacedClassName = NSStringFromClass(testCaseClass)

        guard !QuickSelectedTestSuiteBuilder.builtTestSuites.contains(namespacedClassName) else {
            return nil
        }

        QuickSelectedTestSuiteBuilder.builtTestSuites.insert(namespacedClassName)
    }

    @objc func buildTestSuite() -> QuickTestSuite {
        return QuickTestSuite(forTestCaseClass: testCaseClass)
    }

}
