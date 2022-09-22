import XCTest
@testable import Quick
import Nimble

class FunctionalTests_ItSpec: QuickSpec {
    override func spec() {
        var exampleMetadata: ExampleMetadata?
        beforeEach { metadata in exampleMetadata = metadata }

        it("") {
            expect(exampleMetadata!.example.name).to(equal(""))
        }

        it("has a description with セレクター名に使えない文字が入っている 👊💥") {
            let name = "has a description with セレクター名に使えない文字が入っている 👊💥"
            expect(exampleMetadata!.example.name).to(equal(name))
        }

#if canImport(Darwin)
        describe("when an example has a unique name") {
            it("has a unique name") {}

            it("doesn't add multiple selectors for it") {
                let allSelectors = FunctionalTests_ItSpec.allSelectors()
                    .filter { $0.hasPrefix("when an example has a unique name, ") }
                    .sorted(by: <)

                expect(allSelectors) == [
                    "when an example has a unique name, doesn't add multiple selectors for it",
                    "when an example has a unique name, has a unique name",
                ]
            }
        }

        describe("when two examples have the exact name") {
            it("has exactly the same name") {}
            it("has exactly the same name") {}

            it("makes a unique name for each of the above") {
                let allSelectors = FunctionalTests_ItSpec.allSelectors()
                    .filter { $0.hasPrefix("when two examples have the exact name, ") }
                    .sorted(by: <)

                expect(allSelectors) == [
                    "when two examples have the exact name, has exactly the same name",
                    "when two examples have the exact name, has exactly the same name (2)",
                    "when two examples have the exact name, makes a unique name for each of the above",
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
                    expect(exception!.reason).to(equal("'it' cannot be used inside 'beforeEach', 'it' may only be used inside 'context' or 'describe'."))
                }
            }

            describe("behavior with an 'it' inside an 'afterEach'") {
                var exception: NSException?

                afterEach {
                    let capture = NMBExceptionCapture(handler: ({ e in
                        exception = e
                        expect(exception).toNot(beNil())
                        expect(exception!.reason).to(equal("'it' cannot be used inside 'afterEach', 'it' may only be used inside 'context' or 'describe'."))
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

final class ItTests: XCTestCase, XCTestCaseProvider {
    static var allTests: [(String, (ItTests) -> () throws -> Void)] {
        return [
            ("testAllExamplesAreExecuted", testAllExamplesAreExecuted),
            ("testImplicitErrorHandling", testImplicitErrorHandling),
            ("testSkippingExamplesAreCorrectlyReported", testSkippingExamplesAreCorrectlyReported),
            ("testStoppingExamplesAreCorrectlyReported", testStoppingExamplesAreCorrectlyReported),
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
}
