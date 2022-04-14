#if !SWIFT_PACKAGE

import Foundation
import XCTest

/// A dummy protocol for calling the internal `+[QuickSpec buildExamplesIfNeeded]` method
/// which is defined in Objective-C from Swift.
@objc private protocol _QuickSpecInternal {
    static func buildExamplesIfNeeded()
}

internal final class AllExamplesBuilder {
    private var didBuildAllExamples = false

    /// Calls `buildExamplesIfNeeded` on each `QuickSpec` subclass
    func buildAllExamplesIfNeeded() {
        guard !didBuildAllExamples else { return }
        didBuildAllExamples = true

        QuickSpec.enumerateSubclasses { specClass in
            // This relies on `_QuickSpecInternal`.
            (specClass as AnyClass).buildExamplesIfNeeded()
        }
    }
}

// swiftlint:disable:next todo
// TODO: Unify this with QuickConfiguration's equivalent
private extension QuickSpec {
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
                    superclass.isSubclass(of: QuickSpec.self)
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
