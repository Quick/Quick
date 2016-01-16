import XCTest
import Quick
import Nimble
#if SWIFT_PACKAGE
import QuickTestHelpers
#endif

var beforeSuiteWasExecuted = false

class FunctionalTests_BeforeSuite_BeforeSuiteSpec: QuickSpec {
    override func spec() {
        beforeSuite {
            beforeSuiteWasExecuted = true
        }
    }
}

class FunctionalTests_BeforeSuite_Spec: QuickSpec {
    override func spec() {
        it("is executed after beforeSuite") {
            expect(beforeSuiteWasExecuted).to(beTruthy())
        }
    }
}

class BeforeSuiteTests: XCTestCase, XCTestCaseProvider {
    var allTests: [(String, () -> Void)] {
        return [
            ("testBeforeSuiteIsExecutedBeforeAnyExamples", testBeforeSuiteIsExecutedBeforeAnyExamples),
        ]
    }

    func testBeforeSuiteIsExecutedBeforeAnyExamples() {
        // Execute the spec with an assertion before the one with a beforeSuite
        let result = qck_runSpecs([
            FunctionalTests_BeforeSuite_Spec.self,
            FunctionalTests_BeforeSuite_BeforeSuiteSpec.self
            ])

        XCTAssert(result.hasSucceeded)
    }
}
