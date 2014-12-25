import Quick
import XCTest

class FocusedSpec: QuickSpec {
    override func spec() {
        describe("unfocused examples") {
            it("fails (but is never run)") { XCTFail() }
            it("fails again (but is never run)") { XCTFail() }
        }

        describe("focused examples") {
            it("passes", { }, flags: ["focused": true])
            it("passes again", { }, flags: ["focused": true])
        }
    }
}
