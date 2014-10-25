import XCTest
import Quick
import Nimble

class FunctionalTests_ItSpec: QuickSpec {
    override func spec() {
        var exampleMetadata: ExampleMetadata?
        beforeEach { (metadata: ExampleMetadata) in exampleMetadata = metadata }

        it("") {
            // This is a bug; example names should not include "root example group".
            // See: https://github.com/Quick/Quick/issues/168
            expect(exampleMetadata!.example.name).to(equal("root example group, "))
        }

        it("has a description with セレクター名に使えない文字が入っている 👊💥") {
            let name = "root example group, has a description with セレクター名に使えない文字が入っている 👊💥"
            expect(exampleMetadata!.example.name).to(equal(name))
        }
    }
}

class ItTests: XCTestCase {
    func testAllExamplesAreExecuted() {
        let result = qck_runSpec(FunctionalTests_ItSpec.classForCoder())
        XCTAssertEqual(result.executionCount, 2 as UInt)
    }
}
