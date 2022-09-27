import XCTest
@testable import Quick
import Nimble

class FunctionalTests_JustBeforeEachSpec: QuickSpec {
    enum ApiResponse {
        case Success
        case Failure
    }

    func apiCall(someArgument: Bool) -> ApiResponse {
        return someArgument ? ApiResponse.Success : ApiResponse.Failure
    }

    override func spec() {
        describe("justBeforeEach") {
            var someArgument: Bool!
            var apiResponse: ApiResponse!

            justBeforeEach {
                apiResponse = self.apiCall(someArgument: someArgument)
            }

            context("success") {
                beforeEach {
                    someArgument = true
                }

                it("then it response with Success") {
                    expect(apiResponse).to(equal(ApiResponse.Success))
                }
            }

            context("failure") {
                beforeEach {
                    someArgument = false
                }

                it("then it responds with failure") {
                    expect(apiResponse).to(equal(ApiResponse.Failure))
                }
            }
        }
    }
}
