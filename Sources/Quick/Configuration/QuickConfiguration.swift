import Foundation
import XCTest

#if SWIFT_PACKAGE

/**
 Subclass QuickConfiguration and override the `configure(_:)` class
 method in order to configure how Quick behaves when running specs, or to define
 shared examples that are used across spec files.
 */
open class QuickConfiguration: NSObject {
    /**
     This method is executed on each subclass of this class before Quick runs
     any examples. You may override this method on as many subclasses as you like, but
     there is no guarantee as to the order in which these methods are executed.

     You can override this method in order to:

     1. Configure how Quick behaves, by modifying properties on the Configuration object.
        Setting the same properties in several methods has undefined behavior.

     2. Define shared examples using `sharedExamples`.

     - Parameter configuration: A mutable object that is used to configure how Quick behaves on
                          a framework level. For details on all the options, see the
                          documentation in QCKConfiguration.swift.
     */
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
