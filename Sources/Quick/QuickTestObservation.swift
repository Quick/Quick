#if !SWIFT_PACKAGE

import Foundation
import XCTest

@objc internal final class QuickTestObservation: NSObject, XCTestObservation {
    private let examplesGlobalLoader = QuickTestExamplesLoader.shared

    // Quick hooks into this event to compile example groups for each QuickSpec subclasses.
    func testBundleWillStart(_ testBundle: Bundle) {
        examplesGlobalLoader.buildExamplesIfNeeded()
    }
}

#endif
