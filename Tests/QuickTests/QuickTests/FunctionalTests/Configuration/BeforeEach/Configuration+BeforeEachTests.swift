import XCTest
import Quick
import Nimble

class Configuration_BeforeEachSpec: QuickSpec {
    override func spec() {
        it("is executed after the configuration beforeEach") {
            expect(FunctionalTestsConfigurationBeforeEach.wasExecuted).to(beTruthy())
        }
    }
}

final class Configuration_BeforeEachTests: XCTestCase, XCTestCaseProvider {
    static var allTests: [(String, (Configuration_BeforeEachTests) -> () throws -> Void)] {
        return [
            ("testExampleIsRunAfterTheConfigurationBeforeEachIsExecuted", testExampleIsRunAfterTheConfigurationBeforeEachIsExecuted)
        ]
    }

    func testExampleIsRunAfterTheConfigurationBeforeEachIsExecuted() {
        FunctionalTestsConfigurationBeforeEach.wasExecuted = false

        qck_runSpec(Configuration_BeforeEachSpec.self)
        XCTAssert(FunctionalTestsConfigurationBeforeEach.wasExecuted)

        FunctionalTestsConfigurationBeforeEach.wasExecuted = false
    }
}
