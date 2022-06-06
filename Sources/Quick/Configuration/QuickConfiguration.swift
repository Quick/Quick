import Foundation
import XCTest

#if SWIFT_PACKAGE

open class QuickConfiguration: NSObject {
    open class func configure(_ configuration: QCKConfiguration) {}
}

#endif

extension QuickConfiguration {
    #if !canImport(Darwin)
    private static var configurationSubclasses: [QuickConfiguration.Type] = []
    #endif

    /// Finds all direct subclasses of QuickConfiguration and passes them to the block provided.
    /// The classes are iterated over in the order that objc_getClassList returns them.
    ///
    /// - parameter block: A block that takes a QuickConfiguration.Type.
    ///                    This block will be executed once for each subclass of QuickConfiguration.
    private static func enumerateSubclasses(_ block: (QuickConfiguration.Type) -> Void) {
        #if canImport(Darwin)
        // See https://developer.apple.com/forums/thread/700770.
        var classesCount: UInt32 = 0
        let classList = objc_copyClassList(&classesCount)
        defer { free(UnsafeMutableRawPointer(classList)) }
        let classes = UnsafeBufferPointer(start: classList, count: Int(classesCount))

        guard classesCount > 0 else {
            return
        }

        var configurationSubclasses: [QuickConfiguration.Type] = []
        for subclass in classes {
            guard
                isClass(subclass, aSubclassOf: QuickConfiguration.self)
                else { continue }

            // swiftlint:disable:next force_cast
            configurationSubclasses.append(subclass as! QuickConfiguration.Type)
        }
        #endif

        configurationSubclasses.forEach(block)
    }

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
            enumerateSubclasses { configurationClass in
                configurationClass.configure(configuration)
            }
        }
        world.finalizeConfiguration()
    }
}
