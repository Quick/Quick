import Testing
import QuickTesting

struct MySpec: Spec {
    var body: Behavior {
        let ocean = ["whales", "dolphins"]
        describe("some example group") {
            it("does the thing") {
                #expect(ocean.contains("dolphins"))
            }
        }

        describe("some other example group") {
            it("does the other thing") {
                #expect(ocean.contains("whales"))
            }
        }
    }
}
