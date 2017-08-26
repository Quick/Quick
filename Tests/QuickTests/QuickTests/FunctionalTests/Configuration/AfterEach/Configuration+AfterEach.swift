import Quick

class FunctionalTestsConfigurationAfterEach: QuickConfiguration {
    static var wasExecuted = false
    override class func configure(_ configuration: Configuration) {
        configuration.afterEach {
            wasExecuted = true
        }
    }
}
