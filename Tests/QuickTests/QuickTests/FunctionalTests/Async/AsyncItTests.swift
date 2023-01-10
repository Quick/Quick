import XCTest
import Nimble
@testable import Quick

private var isRunningFunctionalTests = false

enum ExampleError: Error {
    case error
}

func asyncFunction() async {}

func asyncNonThrowingFunction() async throws {}

func asyncThrowingFunction(shouldThrow: Bool) async throws {
    if shouldThrow {
        throw ExampleError.error
    }
}

final class FunctionalTests_AsyncItSpec: AsyncSpec {
    @AsyncSpecBuilder
    override class func spec() -> [AsyncExample] {
        describe("async handling") {
            var beforeEachSet: Bool = false
            beforeEach {
                beforeEachSet = true
            }

            it("listens to beforeEachs") {
                expect(beforeEachSet).to(beTrue())
            }

            it("supports calling async, non-throwing functions") {
                await asyncFunction()
            }

            it("supports calling async functions marked as throws") {
                try await asyncNonThrowingFunction()
            }

            it("supports calling async functions that actually throw") {
                try await asyncThrowingFunction(shouldThrow: isRunningFunctionalTests)
            }

            it("defaults to running async tests off of main") {
                expect(Thread.isMainThread).to(beFalse())
            }

            it("supports running async tests on main, ish") { @MainActor in
                expect(Thread.isMainThread).to(beTrue())
            }
        }
    }
}

final class AsyncItTests: XCTestCase, XCTestCaseProvider {
    static var allTests: [(String, (AsyncItTests) -> () throws -> Void)] {
        return [
            ("testAsyncExamples", testAsyncExamples),
        ]
    }

    override func setUp() {
        super.setUp()
        isRunningFunctionalTests = true
    }

    override func tearDown() {
        isRunningFunctionalTests = false
        super.tearDown()
    }

    func testAsyncExamples() {
        let result = runAsyncSpec(FunctionalTests_AsyncItSpec.self)!
        XCTAssertFalse(result.hasSucceeded)
        XCTAssertEqual(result.executionCount, 6)
        XCTAssertEqual(result.failureCount, 0)
        XCTAssertEqual(result.unexpectedExceptionCount, 1)
        XCTAssertEqual(result.totalFailureCount, 1)
    }
}
