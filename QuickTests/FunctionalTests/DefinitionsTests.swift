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

        var mutatingNumber = 2
        define("number") { return mutatingNumber }

        it("should memoize the value of the first evaluation in each example") {
            let firstFetch = fetch("number") as! Int
            fetches.append(firstFetch)
            mutatingNumber = 3
            let secondFetch = fetch("number") as! Int
            fetches.append(secondFetch)
            expect(secondFetch).to(equal(firstFetch))
        }

        it("should clear memoized values between examples") {
            mutatingNumber = 4
            let number = fetch("number") as! Int
            fetches.append(number)
            expect(number).to(equal(4))
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

    func testFetchesReturnsTheExpectedValues() {
        qck_runSpec(FunctionalTests_DefinitionsSpec)
        let expectedFetches = [1, 2, 2, 4]
        XCTAssertEqual(fetches, expectedFetches)
    }
}