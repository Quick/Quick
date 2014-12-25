import Quick
import XCTest

class FocusedSpec: QuickSpec {
    override func spec() {
        describe("unfocused examples") {
            it("fails (but is never run)") { XCTFail() }
            it("fails again (but is never run)") { XCTFail() }
        }

        it("passes", {}, flags: ["focused": true])

        xit("fails (but is never run)") { XCTFail() }

        fdescribe("focused examples") {
            it("passes") {}
            it("passes again") {}
            xit("fails (but is never run)") { XCTFail() }
        }

        describe("explicitly unfocused examples containing focused ones", {
            fit("fails (but is never run)") { XCTFail() }
        }, flags: ["focused": false])
    }
}
