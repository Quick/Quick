import XCTest
import Quick
import Nimble

class QuickContextTests: QuickSpec {
    override func spec() {
        describe("Context") {
            it("should throw an exception if used in an it block") {
                expect {
                    context("A nested context that should throw") { }
                    }.to(raiseException { (exception: NSException) in
                        expect(exception.name).to(equal("Invalid DSL Exception"))
                        expect(exception.reason).to(equal("'context' cannot be used inside 'it', 'context' may only be used inside 'context' or 'describe'. "))
                        })
            }
        }
    }
}
