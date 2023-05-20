import Quick
import Nimble
import XCTest
import Dispatch

class QuickSpecCurrentTests: QuickSpec {
    override class func spec() {
        it("returns the currently executing spec") {
            let name: String = {
                let result = QuickSpec.current.name
#if canImport(Darwin)
                return result.replacingOccurrences(of: "_", with: " ")
#else
                return result
#endif
            }()
            expect(name).to(match("returns the currently executing spec"))
        }

        let currentSpecDuringSpecSetup = QuickSpec.current

        it("returns nil when no spec is executing") {
            expect(currentSpecDuringSpecSetup).to(beNil())
        }

        it("returns nil when asking for AsyncSpec.current") {
            expect(AsyncSpec.current).to(beNil())
        }

        it("currentSpec() returns the current spec") {
            expect(currentSpec()).to(be(QuickSpec.current))
        }

        it("supports XCTest expectations") {
            let expectation = currentSpec()?.expectation(description: "great expectation")
            DispatchQueue.global(qos: .default).async { expectation!.fulfill() }
            currentSpec()?.waitForExpectations(timeout: 1)
        }
    }
}

class AsyncSpecCurrentTests: AsyncSpec {
    override class func spec() {
        it("returns the currently executing spec") {
            let name: String = {
                let result = AsyncSpec.current.name
#if canImport(Darwin)
                return result.replacingOccurrences(of: "_", with: " ")
#else
                return result
#endif
            }()
            expect(name).to(match("returns the currently executing spec"))
        }

        let currentSpecDuringSpecSetup = AsyncSpec.current

        it("returns nil when no spec is executing") {
            expect(currentSpecDuringSpecSetup).to(beNil())
        }

        it("returns nil when asking for QuickSpec.current") {
            expect(QuickSpec.current).to(beNil())
        }

        it("currentSpec() returns the current spec") {
            expect(currentSpec()).to(be(AsyncSpec.current))
        }

        it("supports XCTest expectations") {
            let expectation = currentSpec()?.expectation(description: "great expectation")
            DispatchQueue.global(qos: .default).async { expectation?.fulfill() }
            await MainActor.run {
                currentSpec()?.waitForExpectations(timeout: 1)
            }
        }
    }
}

class XCTestCurrentSpecTests: XCTestCase {
    func testCurrentSpecReturnsNil() {
        expect(currentSpec()).to(beNil())
    }

    func testQuickSpecCurrentReturnsNil() {
        expect(QuickSpec.current).to(beNil())
    }

    func testAsyncSpecCurrentReturnsNil() {
        expect(AsyncSpec.current).to(beNil())
    }

    static var allTests: [(String, (XCTestCurrentSpecTests) -> () throws -> Void)] {
        return [
            ("testCurrentSpecReturnsNil", testCurrentSpecReturnsNil),
            ("testQuickSpecCurrentReturnsNil", testQuickSpecCurrentReturnsNil),
            ("testAsyncSpecCurrentReturnsNil", testAsyncSpecCurrentReturnsNil),
        ]
    }
}
