internal class QuickSelectedTestSuiteBuilder: QuickTestSuiteBuilder {

    let testCaseClass: AnyClass!

    var namespacedClassName: String {
        return NSStringFromClass(testCaseClass)
    }

    init?(forTestCaseWithName name: String) {
        guard let testCaseClass = testCaseClassForTestCaseWithName(name) else {
            self.testCaseClass = nil
            return nil
        }

        self.testCaseClass = testCaseClass
    }

    func buildTestSuite() -> QuickTestSuite {
        return QuickTestSuite(forTestCaseClass: testCaseClass)
    }

}

private func testCaseClassForTestCaseWithName(name: String) -> AnyClass? {
    func extractClassName(name: String) -> String? {
        return name.characters.split("/").first.map(String.init)
    }

    guard let className = extractClassName(name) else { return nil }
    guard let bundle = NSBundle.currentTestBundle else { return nil }

    if let testCaseClass = bundle.classNamed(className) {
        return testCaseClass
    }

    guard let moduleName = bundle.bundlePath.fileName else { return nil }

    return NSClassFromString("\(moduleName).\(className)")
}
