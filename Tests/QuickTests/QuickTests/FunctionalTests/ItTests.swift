import XCTest
@testable import Quick
import Nimble

class FunctionalTests_ItSpec: QuickSpec {
    override func spec() {
        var exampleMetadata: ExampleMetadata?
        beforeEach { metadata in exampleMetadata = metadata }

        it("") {
            expect(exampleMetadata?.example.name).to(equal(""))
        }

        it("has a description with セレクター名に使えない文字が入っている 👊💥") {
            let name = "has a description with セレクター名に使えない文字が入っている 👊💥"
            expect(exampleMetadata?.example.name).to(equal(name))
        }

#if canImport(Darwin)
        describe("when an example has a unique name") {
            var allSelectors: [String] = []

            beforeEach {
                allSelectors = FunctionalTests_ItSpec.allSelectors()
                    .filter { $0.hasPrefix("when_an_example_has_a_unique_name__") }
                    .sorted(by: <)
            }

            it("has a unique name") {}

            it("doesn't add multiple selectors for it") {
                expect(allSelectors) == [
                    "when_an_example_has_a_unique_name__doesn_t_add_multiple_selectors_for_it:",
                    "when_an_example_has_a_unique_name__has_a_unique_name:",
                ]
            }
        }

        describe("when two examples have the exact name") {
            var allSelectors: [String] = []

            beforeEach {
                allSelectors = FunctionalTests_ItSpec.allSelectors()
                    .filter { $0.hasPrefix("when_two_examples_have_the_exact_name__") }
                    .sorted(by: <)
            }

            it("has exactly the same name") {}
            it("has exactly the same name") {}

            it("makes a unique name for each of the above") {
                expect(allSelectors) == [
                    "when_two_examples_have_the_exact_name__has_exactly_the_same_name:",
                    "when_two_examples_have_the_exact_name__has_exactly_the_same_name_2:",
                    "when_two_examples_have_the_exact_name__makes_a_unique_name_for_each_of_the_above:",
                ]
            }

        }

#if !SWIFT_PACKAGE
        describe("error handling when misusing ordering") {
            it("an it") {
                expect {
                    it("will throw an error when it is nested in another it") { }
                    }.to(raiseException { (exception: NSException) in
                        expect(exception.name).to(equal(NSExceptionName.internalInconsistencyException))
                        expect(exception.reason).to(equal("'it' cannot be used inside 'it', 'it' may only be used inside 'context' or 'describe'."))
                        })
            }

            describe("behavior with an 'it' inside a 'beforeEach'") {
                var exception: NSException?

                beforeEach {
                    let capture = NMBExceptionCapture(handler: ({ e in
                        exception = e
                    }), finally: nil)

                    capture.tryBlock {
                        it("a rogue 'it' inside a 'beforeEach'") { }
                        return
                    }
                }

                it("should have thrown an exception with the correct error message") {
                    expect(exception).toNot(beNil())
                    expect(exception?.reason).to(equal("'it' cannot be used inside 'beforeEach', 'it' may only be used inside 'context' or 'describe'."))
                }
            }

            describe("behavior with an 'it' inside an 'afterEach'") {
                afterEach {
                    let capture = NMBExceptionCapture(handler: ({ e in
                        let exception = e
                        expect(exception).toNot(beNil())
                        expect(exception.reason).to(equal("'it' cannot be used inside 'afterEach', 'it' may only be used inside 'context' or 'describe'."))
                    }), finally: nil)

                    capture.tryBlock {
                        it("a rogue 'it' inside an 'afterEach'") { }
                        return
                    }
                }

                it("should throw an exception with the correct message after this 'it' block executes") {  }
            }
        }
#endif
#endif
    }
}

private var isRunningFunctionalTests = false

class FunctionalTests_ImplicitErrorItSpec: QuickSpec {
    override func spec() {
        describe("implicit error handling") {
            enum ExampleError: Error {
                case error
            }

            func nonThrowingFunc() throws {}

            func throwingFunc(shouldThrow: Bool) throws {
                if shouldThrow {
                    throw ExampleError.error
                }
            }

            it("supports calling functions marked as throws") {
                try nonThrowingFunc()
            }

            it("supports calling functions that actually throws") {
                try throwingFunc(shouldThrow: isRunningFunctionalTests)
            }
        }
    }
}

final class FunctionalTests_SkippingTestsSpec: QuickSpec {
    override func spec() {
        it("supports skipping tests") { throw XCTSkip("This test is intentionally skipped") }
        it("supports not skipping tests") { }
    }
}

final class FunctionalTests_StoppingTestsSpec: QuickSpec {
    override func spec() {
        it("supports silently stopping tests") { throw StopTest.silently }
        it("supports stopping tests with expected errors") {
            if isRunningFunctionalTests {
                throw StopTest("Test stopped due to expected error")
            }
        }
        it("supports not stopping tests") { }
    }
}

final class FunctionalTests_AsyncItSpec: QuickSpec {
    override func spec() {
        describe("async handling") {
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

            it("supports calling async, non-throwing functions") {
                await asyncFunction()
            }

            it("supports calling async functions marked as throws") {
                try await asyncNonThrowingFunction()
            }

            it("supports calling async functions that actually throw") {
                try await asyncThrowingFunction(shouldThrow: isRunningFunctionalTests)
            }
        }
    }
}

final class ItTests: XCTestCase, XCTestCaseProvider {
    static var allTests: [(String, (ItTests) -> () throws -> Void)] {
        return [
            ("testAllExamplesAreExecuted", testAllExamplesAreExecuted),
            ("testImplicitErrorHandling", testImplicitErrorHandling),
            ("testSkippingExamplesAreCorrectlyReported", testSkippingExamplesAreCorrectlyReported),
            ("testStoppingExamplesAreCorrectlyReported", testStoppingExamplesAreCorrectlyReported),
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

    func testAllExamplesAreExecuted() {
        let result = qck_runSpec(FunctionalTests_ItSpec.self)
#if canImport(Darwin)
#if SWIFT_PACKAGE
        XCTAssertEqual(result?.executionCount, 7)
#else
        XCTAssertEqual(result?.executionCount, 10)
#endif
#else
        XCTAssertEqual(result?.executionCount, 2)
#endif
    }

    func testImplicitErrorHandling() {
        let result = qck_runSpec(FunctionalTests_ImplicitErrorItSpec.self)!
        XCTAssertFalse(result.hasSucceeded)
        XCTAssertEqual(result.executionCount, 2)
        XCTAssertEqual(result.failureCount, 0)
        XCTAssertEqual(result.unexpectedExceptionCount, 1)
        XCTAssertEqual(result.totalFailureCount, 1)
    }

    func testSkippingExamplesAreCorrectlyReported() {
        let result = qck_runSpec(FunctionalTests_SkippingTestsSpec.self)!
        XCTAssertTrue(result.hasSucceeded)
        XCTAssertEqual(result.executionCount, 2)
        XCTAssertEqual(result.skipCount, 1)
        XCTAssertEqual(result.totalFailureCount, 0)
    }

    func testStoppingExamplesAreCorrectlyReported() {
        let result = qck_runSpec(FunctionalTests_StoppingTestsSpec.self)!
        XCTAssertFalse(result.hasSucceeded)
        XCTAssertEqual(result.executionCount, 3)
        XCTAssertEqual(result.failureCount, 1)
        XCTAssertEqual(result.unexpectedExceptionCount, 0)
        XCTAssertEqual(result.totalFailureCount, 1)
    }

    func testAsyncExamples() {
        let result = qck_runSpec(FunctionalTests_AsyncItSpec.self)!
        XCTAssertFalse(result.hasSucceeded)
        XCTAssertEqual(result.executionCount, 3)
        XCTAssertEqual(result.failureCount, 0)
        XCTAssertEqual(result.unexpectedExceptionCount, 1)
        XCTAssertEqual(result.totalFailureCount, 1)
    }
}
