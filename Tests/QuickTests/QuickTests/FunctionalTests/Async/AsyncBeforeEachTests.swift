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

class FunctionalTests_AsyncBeforeEachSpec: AsyncSpec {
    @AsyncSpecBuilder
    override class func spec() -> [AsyncExample] {
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
    }
}

class FunctionalTests_AsyncBeforeEach_WithoutOuterDescribe_Spec: AsyncSpec {
    @AsyncSpecBuilder
    override class func spec() -> [AsyncExample] {
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
}

final class AsyncBeforeEachTests: XCTestCase, XCTestCaseProvider {
    static var allTests: [(String, (AsyncBeforeEachTests) -> () throws -> Void)] {
        return [
            ("testBeforeEachIsExecutedInTheCorrectOrder", testBeforeEachIsExecutedInTheCorrectOrder),
            ("testBeforeEachWithoutOuterDescribeExecutedInTheCorrectOrder", testBeforeEachWithoutOuterDescribeExecutedInTheCorrectOrder),
        ]
    }

    func testBeforeEachIsExecutedInTheCorrectOrder() {
        beforeEachOrder = []

        runAsyncSpec(FunctionalTests_AsyncBeforeEachSpec.self)
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

    func testBeforeEachWithoutOuterDescribeExecutedInTheCorrectOrder() {
        beforeEachOrder = []

        runAsyncSpec(FunctionalTests_AsyncBeforeEach_WithoutOuterDescribe_Spec.self)
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
}

