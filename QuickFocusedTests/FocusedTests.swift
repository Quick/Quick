import Quick
import XCTest

class FocusedSpec: QuickSpec {
    override func spec() {
        describe("unfocused examples") {
            it("fails (but is never run)") { XCTFail() }
            it("fails again (but is never run)") { XCTFail() }
        }

        it("passes", {}, flags: ["focused": true])

        describe("focused examples", {
            it("passes") {}
            it("passes again") {}
        }, flags: ["focused": true])

        describe("explicitly unfocused examples containing focused ones", {
            it("fails (but is never run)", { XCTFail() }, flags: ["focused": true])
        }, flags: ["focused": false])
    }
}
