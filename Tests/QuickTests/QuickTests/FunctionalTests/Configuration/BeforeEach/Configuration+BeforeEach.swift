import Quick

class FunctionalTestsConfigurationBeforeEach: QuickConfiguration {
    static var wasExecuted = false
    override class func configure(_ configuration: Configuration) {
        configuration.beforeEach {
            wasExecuted = true
        }
    }
}
