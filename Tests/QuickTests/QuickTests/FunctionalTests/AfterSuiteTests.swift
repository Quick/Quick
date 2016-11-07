import XCTest
import Quick
import Nimble

var afterSuiteWasExecuted = false

class FunctionalTests_AfterSuite_AfterSuiteSpec: QuickSpec {
    override func spec() {
        afterSuite {
            afterSuiteWasExecuted = true
        }
    }
}

class FunctionalTests_AfterSuite_Spec: QuickSpec {
    override func spec() {
        it("is executed before afterSuite") {
            expect(afterSuiteWasExecuted).to(beFalsy())
        }
    }
}

final class AfterSuiteTests: XCTestCase, XCTestCaseProvider {
    static var allTests: [(String, (AfterSuiteTests) -> () throws -> Void)] {
        return [
            ("testAfterSuiteIsNotExecutedBeforeAnyExamples", testAfterSuiteIsNotExecutedBeforeAnyExamples),
        ]
    }

    func testAfterSuiteIsNotExecutedBeforeAnyExamples() {
        // Execute the spec with an assertion after the one with an afterSuite.
        let result = qck_runSpecs([
            FunctionalTests_AfterSuite_AfterSuiteSpec.self,
            FunctionalTests_AfterSuite_Spec.self
            ])

        // afterSuite is broken https://github.com/Quick/Quick/issues/561
        // For fixing this, need to know how it should work.
#if _runtime(_ObjC) && !SWIFT_PACKAGE
        // Although this ensures that afterSuite is not called before any
        // examples, it doesn't test that it's ever called in the first place.
        XCTAssert(result!.hasSucceeded)
#endif
    }
}
