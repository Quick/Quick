import XCTest
import Nimble
import Quick

#if canImport(Darwin) && !SWIFT_PACKAGE

final class DescribeAsyncTests: XCTestCase, XCTestCaseProvider {
    static var allTests: [(String, (DescribeAsyncTests) -> () throws -> Void)] {
        return [
            ("testDescribeThrowsIfUsedOutsideOfQuickSpec", testDescribeThrowsIfUsedOutsideOfQuickSpec),
        ]
    }

    func testDescribeThrowsIfUsedOutsideOfQuickSpec() {
        expect { AsyncSpec.describe("this should throw an exception", closure: {}) }.to(raiseException())
    }
}

class AsyncDescribeTests: AsyncSpec {
    override class func spec() {
        describe("Describe") {
            it("should throw an exception if used in an it block") {
                expect {
                    describe("A nested describe that should throw") { }
                }.to(raiseException { (exception: NSException) in
                    expect(exception.name).to(equal(NSExceptionName.internalInconsistencyException))
                    expect(exception.reason).to(equal("'describe' cannot be used inside 'it', 'describe' may only be used inside 'context' or 'describe'."))
                })
            }
        }
    }
}

#endif
