import XCTest
import Quick
import Nimble

class Configuration_AfterEachAsyncSpec: AsyncSpec {
    override class func spec() {
        beforeEach {
            FunctionalTests_Configuration_AfterEachWasExecuted = false
        }
        it("is executed before the configuration afterEach") {
            expect(FunctionalTests_Configuration_AfterEachWasExecuted).to(beFalsy())
        }
    }
}

final class Configuration_AfterEachAsyncTests: XCTestCase, XCTestCaseProvider {
    static var allTests: [(String, (Configuration_AfterEachAsyncTests) -> () throws -> Void)] {
        return [
            ("testExampleIsRunAfterTheConfigurationBeforeEachIsExecuted", testExampleIsRunAfterTheConfigurationBeforeEachIsExecuted),
        ]
    }

    func testExampleIsRunAfterTheConfigurationBeforeEachIsExecuted() {
        FunctionalTests_Configuration_AfterEachWasExecuted = false

        qck_runSpec(Configuration_AfterEachAsyncSpec.self)
        XCTAssert(FunctionalTests_Configuration_AfterEachWasExecuted)

        FunctionalTests_Configuration_AfterEachWasExecuted = false
    }
}
