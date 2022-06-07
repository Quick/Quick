#if !SWIFT_PACKAGE

import Foundation
import XCTest

/// A dummy protocol for calling the internal `+[QuickSpec buildExamplesIfNeeded]` method
/// which is defined in Objective-C from Swift.
@objc internal protocol _QuickSpecInternal {
    static func buildExamplesIfNeeded()
}

@objc internal final class QuickTestObservation: NSObject, XCTestObservation {
    @objc(sharedInstance)
    static let shared = QuickTestObservation()

    private var didBuildAllExamples = false

    // Quick hooks into this event to compile example groups for each QuickSpec subclasses.
    //
    // If an exception occurs when compiling examples, report it to the user. Chances are they
    // included an expectation outside of a "it", "describe", or "context" block.
    func testBundleWillStart(_ testBundle: Bundle) {
        buildAllExamplesIfNeeded()
    }

    @objc func buildAllExamplesIfNeeded() {
        guard !didBuildAllExamples else { return }
        didBuildAllExamples = true

        allSubclasses(ofType: QuickSpec.self)
            .forEach { (specClass: QuickSpec.Type) in
                // This relies on `_QuickSpecInternal`.
                (specClass as AnyClass).buildExamplesIfNeeded()
            }
    }
}

#endif
