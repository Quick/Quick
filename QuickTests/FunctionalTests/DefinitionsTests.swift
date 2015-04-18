import XCTest
import Quick
import Nimble

private var fetches = [Int]()

class FunctionalTests_DefinitionsSpec: QuickSpec {
    override func spec() {
        define("one") { return 1 }

        it("should evaluate and return the defined variable") {
            let one = fetch("one") as! Int
            fetches.append(one)
            expect(one).to(equal(1))
        }
    }
}

class DefinitionsTests: XCTestCase {
    override func setUp() {
        super.setUp()
        fetches = []
    }
    
    override func tearDown() {
        fetches = []
        super.tearDown()
    }
    
    func testFetchesReturnExpectedValues() {
        qck_runSpec(FunctionalTests_DefinitionsSpec)
        let expectedFetches = [1]
        XCTAssertEqual(fetches, expectedFetches)
    }
}