import Quick

class FunctionalTestsConfigurationAfterEach: QuickConfiguration {
	static public var wasExecuted = false
    override class func configure(_ configuration: Configuration) {
        configuration.afterEach {
            wasExecuted = true
        }
    }
}
