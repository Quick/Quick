import Quick
import XCTest

final class ZFocusedAsyncSpec: AsyncSpec {
    override class func spec() {
        it("does not run an unfocused example in the focused spec") {
            XCTFail("Only focused examples should run")
        }

        fit("runs a focused example") {}

        fdescribe("a focused describe") {
            it("runs its example") {}
        }

        fcontext("a focused context") {
            it("runs its example") {}
        }
    }
}
