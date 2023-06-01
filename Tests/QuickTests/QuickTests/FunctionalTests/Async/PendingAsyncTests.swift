import XCTest
import Quick
import Nimble

private var oneExampleBeforeEachExecutedCount = 0
private var onlyPendingExamplesBeforeEachExecutedCount = 0

class FunctionalTests_PendingAsyncSpec_AsyncBehavior: AsyncBehavior<Void> {
    override static func spec(_ aContext: @escaping () -> Void) {
        it("an example that will not run") {
            expect(true).to(beFalsy())
        }
    }
}
class FunctionalTests_PendingAsyncSpec: AsyncSpec {
    override class func spec() {
        xit("an example that will not run") {
            await expect(true).toEventually(beFalsy())
        }
        xitBehavesLike(FunctionalTests_PendingAsyncSpec_AsyncBehavior.self) { () -> Void in }
        describe("a describe block containing only one enabled example") {
            beforeEach { oneExampleBeforeEachExecutedCount += 1 }
            it("an example that will run") {}
            pending("an example that will not run") {}
        }

        describe("a describe block containing only pending examples") {
            beforeEach { onlyPendingExamplesBeforeEachExecutedCount += 1 }
            pending("an example that will not run") {}
        }
        describe("a describe block with a disabled context that will not run") {
            xcontext("these examples will not run") {
               it("does not run") {
                  fail()
               }
            }
        }
        xdescribe("a describe block that will not run") {
            it("does not run") {
               fail()
            }
        }
    }
}

final class PendingAsyncTests: XCTestCase, XCTestCaseProvider {
    static var allTests: [(String, (PendingAsyncTests) -> () throws -> Void)] {
        return [
            ("testAnOtherwiseFailingExampleWhenMarkedPendingDoesNotCauseTheSuiteToFail", testAnOtherwiseFailingExampleWhenMarkedPendingDoesNotCauseTheSuiteToFail),
            ("testBeforeEachOnlyRunForEnabledExamples", testBeforeEachOnlyRunForEnabledExamples),
            ("testBeforeEachDoesNotRunForContextsWithOnlyPendingExamples", testBeforeEachDoesNotRunForContextsWithOnlyPendingExamples),
        ]
    }

    func testAnOtherwiseFailingExampleWhenMarkedPendingDoesNotCauseTheSuiteToFail() {
        let result = qck_runSpec(FunctionalTests_PendingAsyncSpec.self)
        XCTAssertTrue(result!.hasSucceeded)
    }

    func testBeforeEachOnlyRunForEnabledExamples() {
        oneExampleBeforeEachExecutedCount = 0

        qck_runSpec(FunctionalTests_PendingAsyncSpec.self)
        XCTAssertEqual(oneExampleBeforeEachExecutedCount, 1)
    }

    func testBeforeEachDoesNotRunForContextsWithOnlyPendingExamples() {
        onlyPendingExamplesBeforeEachExecutedCount = 0

        qck_runSpec(FunctionalTests_PendingAsyncSpec.self)
        XCTAssertEqual(onlyPendingExamplesBeforeEachExecutedCount, 0)
    }
}
