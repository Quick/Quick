// This is not shipped publicly with Quick because this extension
// should be included with Result.
// But, feel free to use this snippet until it's included with Swift.

extension Result where Failure == Swift.Error {
    init(capturing: () async throws -> Success) async {
        do {
            self = .success(try await capturing())
        } catch {
            self = .failure(error)
        }
    }
}

import XCTest
import Nimble

final class ResultCapturingAsyncTests: XCTestCase {
    func testCapturingSuccess() async {
        func returnsValue<T>(_ value: T) async throws -> T {
            return value
        }

        await expect {
            await Result {
                try await returnsValue(2)
            }
        }.to(beSuccess(test: { expect($0).to(equal(2)) }))
    }

    func testCapturingError() async {
        func throwsError<T>(_ error: Error) async throws -> T {
            throw error
        }

        enum TestError: Error {
            case uhOh
        }

        await expect {
            await Result<Int, Error> {
                try await throwsError(TestError.uhOh)
            }
        }.to(beFailure(test: { expect($0).to(matchError(TestError.uhOh))}))
    }
}
