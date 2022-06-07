import Foundation
import XCTest

#if SWIFT_PACKAGE

open class QuickConfiguration: NSObject {
    open class func configure(_ configuration: QCKConfiguration) {}
}

#endif

extension QuickConfiguration {
    private static var configurationSubclasses: [QuickConfiguration.Type] = []

    #if canImport(Darwin)
    @objc
    static func configureSubclassesIfNeeded(world: World) {
        _configureSubclassesIfNeeded(world: world)
    }
    #else
    static func configureSubclassesIfNeeded(_ configurationSubclasses: [QuickConfiguration.Type]? = nil, world: World) {
        // Storing subclasses for later use (will be used when running additional test suites)
        if let configurationSubclasses = configurationSubclasses {
            self.configurationSubclasses = configurationSubclasses
        }

        _configureSubclassesIfNeeded(world: world)
    }
    #endif

    private static func _configureSubclassesIfNeeded(world: World) {
        if world.isConfigurationFinalized { return }

        // Perform all configurations (ensures that shared examples have been discovered)
        world.configure { configuration in
            (allSubclasses(ofType: QuickConfiguration.self) + configurationSubclasses)
                .forEach { (configurationClass: QuickConfiguration.Type) in
                configurationClass.configure(configuration)
            }
        }
        world.finalizeConfiguration()
    }
}
