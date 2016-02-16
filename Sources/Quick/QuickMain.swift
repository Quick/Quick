import XCTest

// NOTE: This file is not intended to be included in the Xcode project or CocoaPods.
//       It is picked up by the Swift Package Manager during its build process.

/// When using Quick with swift-corelibs-xctest, automatic discovery of specs and
/// configurations is not available. Instead, you should create a standalone
/// executable and call this function from its main.swift file. This will execute
/// the specs and then terminate the process with an exit code of 0 if the tests
/// passed, or 1 if there were any failures.
///
/// Quick is known to work with the DEVELOPMENT-SNAPSHOT-2016-02-08-a Swift toolchain.
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
