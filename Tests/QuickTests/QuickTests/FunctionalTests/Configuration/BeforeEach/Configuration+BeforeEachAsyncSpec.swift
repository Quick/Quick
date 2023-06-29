import XCTest
import Quick
import Nimble

class Configuration_BeforeEachAsyncSpec: AsyncSpec {
    override class func spec() {
        it("is executed after the configuration beforeEach") {
            expect(FunctionalTests_Configuration_BeforeEachWasExecuted).to(beTruthy())
        }
    }
}

final class Configuration_BeforeEachAsyncTests: XCTestCase, XCTestCaseProvider {
    static var allTests: [(String, (Configuration_BeforeEachAsyncTests) -> () throws -> Void)] {
        return [
            ("testExampleIsRunAfterTheConfigurationBeforeEachIsExecuted", testExampleIsRunAfterTheConfigurationBeforeEachIsExecuted),
        ]
    }

    func testExampleIsRunAfterTheConfigurationBeforeEachIsExecuted() {
        FunctionalTests_Configuration_BeforeEachWasExecuted = false

        qck_runSpec(Configuration_BeforeEachAsyncSpec.self)
        XCTAssert(FunctionalTests_Configuration_BeforeEachWasExecuted)

        FunctionalTests_Configuration_BeforeEachWasExecuted = false
    }
}
