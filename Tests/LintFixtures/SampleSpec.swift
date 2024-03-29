import Quick

final class SampleSpec: QuickSpec {
    override class func spec() {
        // context
        fcontext("focused context") {}
        context("unfocused context") {}
        xcontext("pending context") {}

        // describe
        fdescribe("focused describe") {}
        describe("unfocused describe") {}
        xdescribe("pending describe") {}

        // itBehavesLike
        fitBehavesLike("") {}
        itBehavesLike("") {}
        xitBehavesLike("") {}

        // it
        fit("focused it") {}
        it("unfocused it") {}
        xit("pending it") {}

        // pending
        pending("just pending. Which is treated internally like pending it.") {}
    }
}
