import XCTest

// NOTE: This file is not intended to be included in the Xcode project or CocoaPods.
//       It is picked up by the Swift Package Manager during its build process.

@noreturn public func QCKMain(specs: [XCTestCase], configurations: [QuickConfiguration.Type] = []) {
    // Perform all configuration (ensures that shared examples have been discovered)
    World.sharedWorld.configure { configuration in
        for configurationClass in configurations {
            configurationClass.configure(configuration)
        }
    }
    World.sharedWorld.finalizeConfiguration()

    // Gather all examples (ensures suite hooks have been discovered)
    for case let spec as QuickSpec in specs {
        spec.gatherExamplesIfNeeded()
    }

    XCTMain(specs)
}
