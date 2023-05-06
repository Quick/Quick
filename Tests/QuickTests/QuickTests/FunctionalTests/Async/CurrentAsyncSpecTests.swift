import Quick
import Nimble
import Dispatch

class CurrentAsyncSpecTests: AsyncSpec {
    override class func spec() {
        it("returns nil when asking for QuickSpec.current") {
            expect(QuickSpec.current).to(beNil())
        }

        it("returns the currently executing spec") {
            let name: String = {
                let result = AsyncSpec.current!.name
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

        it("supports XCTest expectations") { @MainActor in
            let expectation = AsyncSpec.current!.expectation(description: "great expectation")
            DispatchQueue.global(qos: .default).async { expectation.fulfill() }
            AsyncSpec.current!.waitForExpectations(timeout: 1)
        }
    }
}
