#if !SWIFT_PACKAGE

import Foundation

/// Singleton which can call `buildExamplesIfNeeded` on each `QuickSpec` subclass once per lifetime of application
@objc internal final class QuickTestExamplesLoader: NSObject {
    @objc(sharedInstance)
    static let shared = QuickTestExamplesLoader()

    private var didBuildExamples = false

    private override init() {}

    /// Iterates over all subclasses of `QuickSpec` and calls `buildExamplesIfNeeded` method on each one once per lifetime of application.
    ///
    /// If an exception occurs when compiling examples, report it to the user. Chances are they
    /// included an expectation outside of a "it", "describe", or "context" block.
    @objc func buildExamplesIfNeeded() {
        guard didBuildExamples == false else { return }
        didBuildExamples = true

        QuickSpec.enumerateSubclasses { specClass in
            // This relies on `_QuickSpecInternal`.
            (specClass as AnyClass).buildExamplesIfNeeded()
        }
    }
}

/// A dummy protocol for calling the internal `+[QuickSpec buildExamplesIfNeeded]` method
/// which is defined in Objective-C from Swift.
@objc protocol _QuickSpecInternal {
    static func buildExamplesIfNeeded()
}

// swiftlint:disable:next todo
// TODO: Unify this with QuickConfiguration's equivalent
extension QuickSpec {
    static func enumerateSubclasses(
        subclasses: [QuickSpec.Type]? = nil,
        _ block: (QuickSpec.Type) -> Void
    ) {
        let subjects: [QuickSpec.Type]
        if let subclasses = subclasses {
            subjects = subclasses
        } else {
            let classesCount = objc_getClassList(nil, 0)

            guard classesCount > 0 else {
                return
            }

            let classes = UnsafeMutablePointer<AnyClass?>.allocate(capacity: Int(classesCount))
            defer { free(classes) }

            objc_getClassList(AutoreleasingUnsafeMutablePointer(classes), classesCount)

            var specSubclasses: [QuickSpec.Type] = []
            for index in 0..<classesCount {
                guard
                    let subclass = classes[Int(index)],
                    let superclass = class_getSuperclass(subclass),
                    superclass is QuickSpec.Type
                    else { continue }

                // swiftlint:disable:next force_cast
                specSubclasses.append(subclass as! QuickSpec.Type)
            }

            subjects = specSubclasses
        }

        subjects.forEach(block)
    }
}

#endif
