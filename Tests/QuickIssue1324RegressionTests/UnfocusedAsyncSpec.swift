import Quick
import XCTest

final class AUnfocusedAsyncSpec: AsyncSpec {
    override class func spec() {
        it("does not run an unfocused example in another spec") {
            XCTFail("The focused example should exclude this example")
        }
    }
}
