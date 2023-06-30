import XCTest
import Quick
import Nimble

private enum BeforeEachType {
    case outerOne
    case outerTwo
    case innerOne
    case innerTwo
    case innerThree
    case noExamples
}

private var beforeEachOrder = [BeforeEachType]()

private enum ThrowingBeforeEachType: String, CustomStringConvertible {
    case outerOne
    case outerTwo
    case outerThree
    case justBeforeEach
    case inner
    case afterEach
    case afterEachInner

    var description: String { rawValue }
}

private var throwingBeforeEachOrder = [ThrowingBeforeEachType]()

private struct BeforeEachError: Error {}

private var isRunningFunctionalTests = false

class FunctionalTests_BeforeEachAsyncSpec: AsyncSpec {
    override class func spec() {

        describe("beforeEach ordering") {
            beforeEach { beforeEachOrder.append(.outerOne) }
            beforeEach { beforeEachOrder.append(.outerTwo) }

            it("executes the outer beforeEach closures once [1]") {}
            it("executes the outer beforeEach closures a second time [2]") {}

            context("when there are nested beforeEach") {
                beforeEach { beforeEachOrder.append(.innerOne) }
                beforeEach { beforeEachOrder.append(.innerTwo) }
                beforeEach { beforeEachOrder.append(.innerThree) }

                it("executes the outer and inner beforeEach closures [3]") {}
            }

            context("when there are nested beforeEach without examples") {
                beforeEach { beforeEachOrder.append(.noExamples) }
            }
        }

        describe("throwing errors") {
            justBeforeEach { throwingBeforeEachOrder.append(.justBeforeEach) }
            beforeEach { throwingBeforeEachOrder.append(.outerOne) }

            beforeEach {
                throwingBeforeEachOrder.append(.outerTwo)
                if isRunningFunctionalTests {
                    throw BeforeEachError()
                }
            }

            beforeEach {
                throwingBeforeEachOrder.append(.outerThree)
            }

            afterEach { throwingBeforeEachOrder.append(.afterEach) }

            it("does not run tests") {
                if isRunningFunctionalTests {
                    fail("tests should not be run here")
                }
            }

            context("when nested") {
                beforeEach {
                    throwingBeforeEachOrder.append(.inner)
                }

                afterEach {
                    throwingBeforeEachOrder.append(.afterEachInner)
                }

                it("still does not run tests") {
                    if isRunningFunctionalTests {
                        fail("tests should not be run.")
                    }
                }
            }
        }

#if canImport(Darwin) && !SWIFT_PACKAGE
        describe("error handling when misusing ordering") {
            it("should throw an exception when including beforeEach in it block") {
                expect {
                    beforeEach { }
                    }.to(raiseException { (exception: NSException) in
                        expect(exception.name).to(equal(NSExceptionName.internalInconsistencyException))
                        expect(exception.reason).to(equal("'beforeEach' cannot be used inside 'it', 'beforeEach' may only be used inside 'context' or 'describe'."))
                        })
            }
        }
#endif
    }
}

final class BeforeEachAsyncTests: XCTestCase, XCTestCaseProvider {
    static var allTests: [(String, (BeforeEachAsyncTests) -> () throws -> Void)] {
        return [
            ("testBeforeEachIsExecutedInTheCorrectOrder", testBeforeEachIsExecutedInTheCorrectOrder),
            ("testBeforeEachWhenThrowingStopsRunningTestsButDoesCallAfterEachs", testBeforeEachWhenThrowingStopsRunningTestsButDoesCallAfterEachs),
        ]
    }

    override func setUp() {
        isRunningFunctionalTests = true
    }

    override func tearDown() {
        isRunningFunctionalTests = false
    }

    func testBeforeEachIsExecutedInTheCorrectOrder() {
        beforeEachOrder = []

        qck_runSpec(FunctionalTests_BeforeEachAsyncSpec.self)
        let expectedOrder: [BeforeEachType] = [
            // [1] The outer beforeEach closures are executed from top to bottom.
            .outerOne, .outerTwo,
            // [2] The outer beforeEach closures are executed from top to bottom.
            .outerOne, .outerTwo,
            // [3] The outer beforeEach closures are executed from top to bottom,
            //     then the inner beforeEach closures are executed from top to bottom.
            .outerOne, .outerTwo, .innerOne, .innerTwo, .innerThree,
        ]
        XCTAssertEqual(beforeEachOrder, expectedOrder)
    }

    func testBeforeEachWhenThrowingStopsRunningTestsButDoesCallAfterEachs() {
        throwingBeforeEachOrder = []

        qck_runSpec(FunctionalTests_BeforeEachAsyncSpec.self)

        let expectedOrder: [ThrowingBeforeEachType] = [
            // It runs the first beforeEach, which doesn't throw.
            .outerOne,
            // It runs the second beforeEach, which throws after recording that it ran
            .outerTwo,
            // It doesn't run the third beforeEach.
            // It doesn't run the test.
            // It does run the teardowns.
            .afterEach,
            // and then repeat because there are two tests.
            .outerOne,
            .outerTwo,
            .afterEach
        ]

        XCTAssertEqual(
            throwingBeforeEachOrder,
            expectedOrder
        )
    }
}
