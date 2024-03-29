import XCTest
import Quick
import Nimble

private enum AfterEachType {
    case outerOne
    case outerTwo
    case outerThree
    case innerOne
    case innerTwo
    case noExamples
}

private var afterEachOrder = [AfterEachType]()

private enum ThrowingAfterEachType: String, CustomStringConvertible {
    case outerOne
    case outerTwo
    case innerOne
    case innerTwo
    case innerThree

    var description: String { rawValue }
}

private var throwingAfterEachOrder = [ThrowingAfterEachType]()

private struct AfterEachError: Error {}

private var isRunningFunctionalTests = false

class FunctionalTests_AfterEachSpec: QuickSpec {
    override class func spec() {
        describe("afterEach ordering") {
            afterEach { afterEachOrder.append(.outerOne) }
            afterEach { afterEachOrder.append(.outerTwo) }
            afterEach { afterEachOrder.append(.outerThree) }

            it("executes the outer afterEach closures once, but not before this closure [1]") {
                // No examples have been run, so no afterEach will have been run either.
                // The list should be empty.
                expect(afterEachOrder).to(beEmpty())
            }

            it("executes the outer afterEach closures a second time, but not before this closure [2]") {
                // The afterEach for the previous example should have been run.
                // The list should contain the afterEach for that example, executed from top to bottom.
                expect(afterEachOrder).to(equal([.outerOne, .outerTwo, .outerThree]))
            }

            context("when there are nested afterEach") {
                afterEach { afterEachOrder.append(.innerOne) }
                afterEach { afterEachOrder.append(.innerTwo) }

                it("executes the outer and inner afterEach closures, but not before this closure [3]") {
                    // The afterEach for the previous two examples should have been run.
                    // The list should contain the afterEach for those example, executed from top to bottom.
                    expect(afterEachOrder).to(equal([
                        .outerOne, .outerTwo, .outerThree,
                        .outerOne, .outerTwo, .outerThree,
                    ]))
                }
            }

            context("when there are nested afterEach without examples") {
                afterEach { afterEachOrder.append(.noExamples) }
            }
        }

        describe("throwing errors") {
            afterEach { throwingAfterEachOrder.append(.outerOne) }

            context("when nested") {
                beforeEach {
                    throwingAfterEachOrder.append(.innerOne)
                }

                afterEach {
                    throwingAfterEachOrder.append(.innerTwo)
                    if isRunningFunctionalTests {
                        throw AfterEachError()
                    }
                }

                afterEach {
                    throwingAfterEachOrder.append(.innerThree)
                }

                it("runs this test") {}
            }
        }

#if canImport(Darwin) && !SWIFT_PACKAGE
        describe("error handling when misusing ordering") {
            it("should throw an exception when including afterEach in it block") {
                expect {
                    afterEach { }
                    }.to(raiseException { (exception: NSException) in
                        expect(exception.name).to(equal(NSExceptionName.internalInconsistencyException))
                        expect(exception.reason).to(equal("'afterEach' cannot be used inside 'it', 'afterEach' may only be used inside 'context' or 'describe'."))
                        })
            }
        }
#endif
    }
}

private var skippingAfterEachOrder = [ThrowingAfterEachType]()

class FunctionalTests_AfterEachSkippingSpec: QuickSpec {
    override class func spec() {
        describe("skipping tests") {
            afterEach {
                if isRunningFunctionalTests {
                    throw XCTSkip("this test is intentionally skipped")
                }
            }

            afterEach {
                skippingAfterEachOrder.append(.outerTwo)
            }

            it("skips this test's afterEach") {
                skippingAfterEachOrder.append(.outerOne)
            }
        }
    }
}

private var stoppingAfterEachOrder = [ThrowingAfterEachType]()

class FunctionalTests_AfterEachStoppingSpec: QuickSpec {
    override class func spec() {
        describe("stopping tests") {
            context("silently stopping") {
                afterEach {
                    if isRunningFunctionalTests {
                        throw StopTest.silently
                    }
                }

                afterEach {
                    stoppingAfterEachOrder.append(.outerTwo)
                }

                it("supports silently stopping tests") {
                    stoppingAfterEachOrder.append(.outerOne)
                }
            }

            context("stopping tests with expected tests") {
                afterEach {
                    if isRunningFunctionalTests {
                        throw StopTest("some error")
                    }
                }

                afterEach {
                    stoppingAfterEachOrder.append(.outerTwo)
                }

                it("supports stopping tests with an error message") {
                    stoppingAfterEachOrder.append(.outerOne)
                }
            }
        }
    }
}

final class AfterEachTests: XCTestCase, XCTestCaseProvider {
    static var allTests: [(String, (AfterEachTests) -> () throws -> Void)] {
        return [
            ("testAfterEachIsExecutedInTheCorrectOrder", testAfterEachIsExecutedInTheCorrectOrder),
            ("testAfterEachWhenThrowingStopsRunningAdditionalAfterEachs", testAfterEachWhenThrowingStopsRunningAdditionalAfterEachs),
            ("testSkippingExamplesAreCorrectlyReported", testSkippingExamplesAreCorrectlyReported),
            ("testStoppingExamplesAreCorrectlyReported", testStoppingExamplesAreCorrectlyReported),
        ]
    }

    override func setUp() {
        afterEachOrder = []
        throwingAfterEachOrder = []
        isRunningFunctionalTests = true
    }

    override func tearDown() {
        afterEachOrder = []
        throwingAfterEachOrder = []
        isRunningFunctionalTests = false
    }

    func testAfterEachIsExecutedInTheCorrectOrder() {
        qck_runSpec(FunctionalTests_AfterEachSpec.self)
        let expectedOrder: [AfterEachType] = [
            // [1] The outer afterEach closures are executed from top to bottom.
            .outerOne, .outerTwo, .outerThree,
            // [2] The outer afterEach closures are executed from top to bottom.
            .outerOne, .outerTwo, .outerThree,
            // [3] The inner afterEach closures are executed from top to bottom,
            //     then the outer afterEach closures are executed from top to bottom.
            .innerOne, .innerTwo, .outerOne, .outerTwo, .outerThree,
        ]
        XCTAssertEqual(afterEachOrder, expectedOrder)
    }

    func testAfterEachWhenThrowingStopsRunningAdditionalAfterEachs() {
        qck_runSpec(FunctionalTests_AfterEachSpec.self)

        let expectedOrder: [ThrowingAfterEachType] = [
            .innerOne,
            .innerTwo,
            .innerThree,
            .outerOne
        ]

        XCTAssertEqual(
            throwingAfterEachOrder,
            expectedOrder
        )
    }

    func testSkippingExamplesAreCorrectlyReported() {
        skippingAfterEachOrder = []

        let result = qck_runSpec(FunctionalTests_AfterEachSkippingSpec.self)!
        XCTAssertTrue(result.hasSucceeded)
        XCTAssertEqual(result.executionCount, 1)
        XCTAssertEqual(result.skipCount, 1)
        XCTAssertEqual(result.totalFailureCount, 0)

        XCTAssertEqual(
            skippingAfterEachOrder,
            [.outerOne, .outerTwo] // it runs the test, and continues running the subsequent afterEachs
        )
    }

    func testStoppingExamplesAreCorrectlyReported() {
        stoppingAfterEachOrder = []

        let result = qck_runSpec(FunctionalTests_AfterEachStoppingSpec.self)!
        XCTAssertFalse(result.hasSucceeded)
        XCTAssertEqual(result.executionCount, 2)
        XCTAssertEqual(result.failureCount, 1)
        XCTAssertEqual(result.unexpectedExceptionCount, 0)
        XCTAssertEqual(result.totalFailureCount, 1)

        XCTAssertEqual(
            stoppingAfterEachOrder,
            [.outerOne, .outerTwo, .outerOne, .outerTwo] // it continues running subsequent afterEachs
        )
    }
}
