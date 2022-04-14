#if !SWIFT_PACKAGE

import Quick
import Nimble
import XCTest

class _Xcode13dot3Tests: QuickSpec {
    override func spec() {
        it("should be executed") {}
    }
}

// According this issue: https://github.com/Quick/Quick/issues/1123
final class Xcode13dot3Tests: XCTestCase, XCTestCaseProvider {
    static var allTests: [(String, (Xcode13dot3Tests) -> () throws -> Void)] {
        return [
            ("testExamplesAreExecutedEvenIfNotificationDoesNotWork", testExamplesAreExecutedEvenIfNotificationDoesNotWork),
        ]
    }

    func testExamplesAreExecutedEvenIfNotificationDoesNotWork() {
        let result = qck_runSpec(
            _Xcode13dot3Tests.self,
            // explicitly disable centralized building all examples of all QuickSpec subclasses
            // because in Xcode 13.3 it works this way (notification testBundleWillStart comes too late)
            gatherExamples: false
        )

        XCTAssertEqual(result?.executionCount, 1)
    }
}

#endif
