import XCTest
import Quick
import Nimble

class Configuration_BeforeEachSpec: QuickSpec {
    override func spec() {
        it("is executed after the configuration beforeEach") {
            expect(FunctionalTests_Configuration_BeforeEachWasExecuted).to(beTruthy())
        }
    }
}

class Configuration_BeforeEachTests: XCTestCase, XCTestCaseProvider {
    var allTests: [(String, () -> Void)] {
        return [
            ("testExampleIsRunAfterTheConfigurationBeforeEachIsExecuted", testExampleIsRunAfterTheConfigurationBeforeEachIsExecuted),
        ]
    }

    func testExampleIsRunAfterTheConfigurationBeforeEachIsExecuted() {
        FunctionalTests_Configuration_BeforeEachWasExecuted = false

        qck_runSpec(Configuration_BeforeEachSpec.classForCoder())
        XCTAssert(FunctionalTests_Configuration_BeforeEachWasExecuted)

        FunctionalTests_Configuration_BeforeEachWasExecuted = false
    }
}
