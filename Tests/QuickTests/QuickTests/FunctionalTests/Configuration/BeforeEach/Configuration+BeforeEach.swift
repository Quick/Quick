import Quick

class FunctionalTestsConfigurationBeforeEach: QuickConfiguration {
	static public var wasExecuted = false
    override class func configure(_ configuration: Configuration) {
        configuration.beforeEach {
            wasExecuted = true
        }
    }
}
