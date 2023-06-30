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
    case innerOne
    case innerTwo
    case innerThree

    var description: String { rawValue }
}

private var throwingAfterEachOrder = [ThrowingAfterEachType]()

private struct AfterEachError: Error {}

private var isRunningFunctionalTests = false

class FunctionalTests_AfterEachAsyncSpec: AsyncSpec {
    override class func spec() {
        describe("afterEach ordering") {
            afterEach { afterEachOrder.append(.outerOne) }
            afterEach { afterEachOrder.append(.outerTwo) }
            afterEach { afterEachOrder.append(.outerThree) }

            it("(1) executes the outer afterEach closures once, but not before this closure") {
                // No examples have been run, so no afterEach will have been run either.
                // The list should be empty.
                expect(afterEachOrder).to(beEmpty())
            }

            it("(2) executes the outer afterEach closures a second time, but not before this closure") {
                // The afterEach for the previous example should have been run.
                // The list should contain the afterEach for that example, executed from top to bottom.
                expect(afterEachOrder).to(equal([.outerOne, .outerTwo, .outerThree]))
            }

            context("when there are nested afterEach") {
                afterEach { afterEachOrder.append(.innerOne) }
                afterEach { afterEachOrder.append(.innerTwo) }

                it("(3) executes the outer and inner afterEach closures, but not before this closure") {
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

final class AfterEachAsyncTests: XCTestCase, XCTestCaseProvider {
    static var allTests: [(String, (AfterEachAsyncTests) -> () throws -> Void)] {
        return [
            ("testAfterEachIsExecutedInTheCorrectOrder", testAfterEachIsExecutedInTheCorrectOrder),
            ("testAfterEachWhenThrowingStopsRunningAdditionalAfterEachs", testAfterEachWhenThrowingStopsRunningAdditionalAfterEachs),
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
        qck_runSpec(FunctionalTests_AfterEachAsyncSpec.self)
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
        qck_runSpec(FunctionalTests_AfterEachAsyncSpec.self)

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
}
