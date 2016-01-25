import XCTest
import Quick
import Nimble
#if SWIFT_PACKAGE
import QuickTestHelpers
#endif

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
        
        it("is a test with a unique name") {
            let allSelectors: Set<String> = FunctionalTests_ItSpec.allSelectors();
            
            expect(allSelectors).to(contain("is_a_test_with_a_unique_name"));
            expect(allSelectors).toNot(contain("is_a_test_with_a_unique_name_2"));
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
        let result = qck_runSpec(FunctionalTests_ItSpec.self)
        XCTAssertEqual(result.executionCount, 3 as UInt)
    }
}
