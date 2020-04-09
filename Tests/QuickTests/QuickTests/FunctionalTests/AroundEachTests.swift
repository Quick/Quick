import XCTest
import Quick
import Nimble

class FunctionalTests_AroundEachSpec: QuickSpec {
    override func spec() {
#if canImport(Darwin) && !SWIFT_PACKAGE
        describe("error handling when misusing ordering") {
            it("should throw an exception when including aroundEach in it block") {
                expect {
                    aroundEach { _ in }
                }.to(raiseException { (exception: NSException) in
                    expect(exception.name).to(equal(NSExceptionName.internalInconsistencyException))
                    expect(exception.reason).to(equal("'aroundEach' cannot be used inside 'it', 'aroundEach' may only be used inside 'context' or 'describe'. "))
                })
            }
        }
#endif
    }
}
