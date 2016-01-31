import XCTest
import Quick
import Nimble
#if SWIFT_PACKAGE
import QuickTestHelpers
#endif

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

class AfterSuiteTests: XCTestCase, XCTestCaseProvider {
    var allTests: [(String, () throws -> Void)] {
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

        // Although this ensures that afterSuite is not called before any
        // examples, it doesn't test that it's ever called in the first place.
        XCTAssert(result.hasSucceeded)
    }
}
