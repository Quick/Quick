import XCTest
import Quick
import Nimble

class FunctionalTests_ItSpec: QuickSpec {
    override func spec() {
        var exampleMetadata: ExampleMetadata?
        beforeEach { metadata in exampleMetadata = metadata }

        it("") {
            expect(exampleMetadata!.example.name).to(equal(""))
        }

        it("has a description with セレクター名に使えない文字が入っている 👊💥") {
            let name = "has a description with セレクター名に使えない文字が入っている 👊💥"
            expect(exampleMetadata!.example.name).to(equal(name))
        }
    }
}

class ItTests: XCTestCase, XCTestCaseProvider {
    var allTests: [(String, () -> Void)] {
        return [
            ("testAllExamplesAreExecuted", testAllExamplesAreExecuted),
        ]
    }

    func testAllExamplesAreExecuted() {
        let result = qck_runSpec(FunctionalTests_ItSpec.classForCoder())
        XCTAssertEqual(result.executionCount, 2 as UInt)
    }
}
