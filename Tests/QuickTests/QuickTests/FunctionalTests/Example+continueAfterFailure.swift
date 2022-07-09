import XCTest
import Quick
import Nimble

private var isRunningFunctionalTests = false

private struct RunTestState {
    var didRunAfterEaches = false
    var didContinueTestAfterFailure = false
}

private var didRunTestsAfterFailure_continueRunningTestAfterFailure_is_false = RunTestState()
private var didRunTestsAfterFailure_continueRunningTestAfterFailure_is_true = RunTestState()

class Example_ContinueAfterFailureSpec: QuickSpec {
    override func spec() {
        describe("when continueRunningTestAfterFailure is false") {
            beforeEach { exampleMetadata in
                didRunTestsAfterFailure_continueRunningTestAfterFailure_is_false = RunTestState()
                exampleMetadata.example.continueRunningTestAfterFailure = false
            }

            afterEach {
                didRunTestsAfterFailure_continueRunningTestAfterFailure_is_false.didRunAfterEaches = true
            }

            it("stops executing after a failure") {
                guard isRunningFunctionalTests else { return }

                fail("This is expected to fail")
                didRunTestsAfterFailure_continueRunningTestAfterFailure_is_false.didContinueTestAfterFailure = true
            }
        }

        describe("when continueRunningTestAfterFailure is true") {
            beforeEach { exampleMetadata in
                didRunTestsAfterFailure_continueRunningTestAfterFailure_is_true = RunTestState()
                exampleMetadata.example.continueRunningTestAfterFailure = true
            }

            afterEach {
                didRunTestsAfterFailure_continueRunningTestAfterFailure_is_true.didRunAfterEaches = true
            }

            it("continues executing after a failure") {
                guard isRunningFunctionalTests else { return }

                fail("This is expected to fail")
                didRunTestsAfterFailure_continueRunningTestAfterFailure_is_true.didContinueTestAfterFailure = true
            }
        }
    }
}

final class Example_ContinueAfterFailureTests: XCTestCase, XCTestCaseProvider {
    static var allTests: [(String, (Example_ContinueAfterFailureTests) -> () throws -> Void)] {
        [
            ("testExamplesWillContinueAfterFailureWhileThatPropertyIsTrue", testExamplesWillContinueAfterFailureWhileThatPropertyIsTrue),
        ]
    }

    func testExamplesWillContinueAfterFailureWhileThatPropertyIsTrue() {
        isRunningFunctionalTests = true
        defer {
            isRunningFunctionalTests = false
        }

        qck_runSpec(Example_ContinueAfterFailureSpec.self)
        XCTAssertFalse(didRunTestsAfterFailure_continueRunningTestAfterFailure_is_false.didContinueTestAfterFailure)
        XCTAssertTrue(didRunTestsAfterFailure_continueRunningTestAfterFailure_is_true.didContinueTestAfterFailure)

        // Does not necessarily runs the afterEaches.
        XCTAssertFalse(didRunTestsAfterFailure_continueRunningTestAfterFailure_is_false.didRunAfterEaches)
        XCTAssertTrue(didRunTestsAfterFailure_continueRunningTestAfterFailure_is_true.didRunAfterEaches)
    }
}

