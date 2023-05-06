import Quick
import Nimble

// This is a functional test ensuring that no crash occurs when a spec class
// references another spec class during its spec setup.

class FunctionalTests_CrossReferencingAsyncSpecA: AsyncSpec {
    override class func spec() {
        _ = FunctionalTests_CrossReferencingAsyncSpecB()
        it("does not crash") {}
    }
}

class FunctionalTests_CrossReferencingAsyncSpecB: AsyncSpec {
    override class func spec() {
        _ = FunctionalTests_CrossReferencingAsyncSpecA()
        it("does not crash") {}
    }
}
