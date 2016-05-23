import XCTest
import Quick
import Nimble
#if SWIFT_PACKAGE
import QuickTestHelpers
#endif

var isBeforeSuiteCalled = false
var isAfterSuiteCalled = false
var isBeforeEachCalled = false
var isAfterEachCalled = false

class FunctionalTests_PendingSpec: QuickSpec {
    override func spec() {
        describe("a describe block containing only pending examples") {
            beforeSuite { isBeforeSuiteCalled = true }
            beforeEach { isBeforeEachCalled = true }
            pending("an example that will not run") {}
            afterEach { isAfterEachCalled = true }
            afterSuite { isAfterSuiteCalled = true }
        }
    }
}

class FunctionalTests_PendingBeforeSuite_Spec: QuickSpec {
    override func spec() {
        it("is executed after beforeSuite") {
            expect(isBeforeSuiteCalled).to(beTruthy())
        }
    }
}

class FunctionalTests_PendingAfterSuite_Spec: QuickSpec {
    override func spec() {
        it("is executed before afterSuite") {
            expect(isAfterSuiteCalled).to(beFalsy())
        }
    }
}

class PendingTests: XCTestCase, XCTestCaseProvider {
    var allTests: [(String, () throws -> Void)] {
        return [
            ("testAnOtherwiseFailingExampleWhenMarkedPendingDoesNotCauseTheSuiteToFail", testAnOtherwiseFailingExampleWhenMarkedPendingDoesNotCauseTheSuiteToFail),
            ("testBeforeEachAfterEachAlwaysRunForPendingExamples", testBeforeEachAfterEachAlwaysRunForPendingExamples),
            ]
    }

    func testAnOtherwiseFailingExampleWhenMarkedPendingDoesNotCauseTheSuiteToFail() {
        let result = qck_runSpec(FunctionalTests_PendingSpec.self)
        XCTAssert(result.hasSucceeded)
    }

    func testBeforeEachAfterEachAlwaysRunForPendingExamples() {
        isBeforeEachCalled = false
        isAfterEachCalled = false

        qck_runSpecs([
            FunctionalTests_PendingSpec.self,
            FunctionalTests_PendingAfterSuite_Spec.self,
            FunctionalTests_PendingAfterSuite_Spec.self
            ])

        XCTAssertEqual(isBeforeEachCalled, true)
        XCTAssertEqual(isAfterEachCalled, true)
    }
}
