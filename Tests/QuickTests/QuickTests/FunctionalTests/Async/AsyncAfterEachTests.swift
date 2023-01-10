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

class FunctionalTests_AsyncAfterEachSpec: AsyncSpec {
    @AsyncSpecBuilder
    override class func spec() -> [AsyncExample] {
        describe("afterEach ordering") {
            afterEach { afterEachOrder.append(.outerOne) }
            afterEach { afterEachOrder.append(.outerTwo) }
            afterEach { afterEachOrder.append(.outerThree) }

            it("1 executes the outer afterEach closures once, but not before this closure") {
                // No examples have been run, so no afterEach will have been run either.
                // The list should be empty.
                expect(afterEachOrder).to(beEmpty())
            }

            it("2 executes the outer afterEach closures a second time, but not before this closure") {
                // The afterEach for the previous example should have been run.
                // The list should contain the afterEach for that example, executed from top to bottom.
                expect(afterEachOrder).to(equal([.outerOne, .outerTwo, .outerThree]))
            }

            context("when there are nested afterEach") {
                afterEach { afterEachOrder.append(.innerOne) }
                afterEach { afterEachOrder.append(.innerTwo) }

                it("3 executes the outer and inner afterEach closures, but not before this closure") {
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
    }
}

final class AsyncAfterEachTests: XCTestCase, XCTestCaseProvider {
    static var allTests: [(String, (AsyncAfterEachTests) -> () throws -> Void)] {
        return [
            ("testAfterEachIsExecutedInTheCorrectOrder", testAfterEachIsExecutedInTheCorrectOrder),
        ]
    }

    func testAfterEachIsExecutedInTheCorrectOrder() {
        afterEachOrder = []

        runAsyncSpec(FunctionalTests_AsyncAfterEachSpec.self)
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

        afterEachOrder = []
    }
}

