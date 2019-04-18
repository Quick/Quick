import Foundation
import XCTest

#if SWIFT_PACKAGE

open class QuickConfiguration: NSObject {
    open class func configure(_ configuration: Configuration) {}
}

#endif

#if canImport(Darwin)

extension QuickConfiguration {

    /// Finds all direct subclasses of QuickConfiguration and passes them to the block provided.
    /// The classes are iterated over in the order that objc_getClassList returns them.
    ///
    /// - parameter block: A block that takes a QuickConfiguration.Type.
    ///                    This block will be executed once for each subclass of QuickConfiguration.
    @objc static func enumerateSubclasses(_ block: (QuickConfiguration.Type) -> Void) {
        var classesCount = objc_getClassList(nil, 0)

        guard classesCount > 0 else {
            return
        }

        let classes = UnsafeMutablePointer<AnyClass?>.allocate(capacity: Int(classesCount))
        defer { free(classes) }

        classesCount = objc_getClassList(AutoreleasingUnsafeMutablePointer(classes), classesCount)

        for i in 0..<classesCount {
            guard
                let subclass = classes[Int(i)],
                let superclass = class_getSuperclass(subclass),
                superclass == QuickConfiguration.self
                else { continue }

            // swiftlint:disable:next force_cast
            block(subclass as! QuickConfiguration.Type)
        }
    }
}

#endif
