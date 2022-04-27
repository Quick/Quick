#if !SWIFT_PACKAGE

import Foundation
import XCTest

@objc internal final class QuickTestObservation: NSObject, XCTestObservation {
    // Quick hooks into this event to compile example groups for each QuickSpec subclasses.
    //
    // If an exception occurs when compiling examples, report it to the user. Chances are they
    // included an expectation outside of a "it", "describe", or "context" block.
    func testBundleWillStart(_ testBundle: Bundle) {
        let world = World.sharedWorld
        world.buildAllExamplesIfNeeded()
    }
}

#endif
