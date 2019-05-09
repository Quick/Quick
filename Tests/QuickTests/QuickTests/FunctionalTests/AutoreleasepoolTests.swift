import XCTest
import Quick
import Nimble

private enum ExecutionOrderType {
    case outerBeforeEachAutoreleasePool
    case outerAfterEachAutoreleasePool
    case outerBeforeEach
    case outerAfterEach

    case innerBeforeEachAutoreleasePool
    case innerAfterEachAutoreleasePool
    case innerBeforeEach
    case innerAfterEach

    case example1
    case example2

    case noExamples
}

private var executionOrder = [ExecutionOrderType]()

class FunctionalTests_AutoreleasepoolSpec: QuickSpec {
    override func spec() {
        describe("execution order") {
            beforeEachAutoreleasepool { executionOrder.append(.outerBeforeEachAutoreleasePool) }
            afterEachAutoreleasepool { executionOrder.append(.outerAfterEachAutoreleasePool) }

            beforeEach { executionOrder.append(.outerBeforeEach) }
            afterEach { executionOrder.append(.outerAfterEach) }

            it("executes only outer closures [1]") { executionOrder.append(.example1) }

            context("when there are nested closures") {
                beforeEachAutoreleasepool { executionOrder.append(.innerBeforeEachAutoreleasePool) }
                afterEachAutoreleasepool { executionOrder.append(.innerAfterEachAutoreleasePool) }

                beforeEach { executionOrder.append(.innerBeforeEach) }
                afterEach { executionOrder.append(.innerAfterEach) }

                it("executes the outer and inner closures [2]") { executionOrder.append(.example2) }
            }

            context("when there are nested closures without examples") {
                beforeEachAutoreleasepool { executionOrder.append(.noExamples) }
                afterEachAutoreleasepool { executionOrder.append(.noExamples) }
            }
        }

#if canImport(Darwin) && !SWIFT_PACKAGE
        describe("error handling when misusing ordering") {
            it("should throw an exception when including beforeEachAutoreleasepool in it block") {
                expect {
                    beforeEachAutoreleasepool { }
                }.to(raiseException { (exception: NSException) in
                    expect(exception.name).to(equal(NSExceptionName.internalInconsistencyException))
                    expect(exception.reason).to(equal("'beforeEachAutoreleasepool' cannot be used inside 'it', 'beforeEachAutoreleasepool' may only be used inside 'context' or 'describe'. "))
                })
            }

            it("should throw an exception when including afterEachAutoreleasepool in it block") {
                expect {
                    afterEachAutoreleasepool { }
                }.to(raiseException { (exception: NSException) in
                    expect(exception.name).to(equal(NSExceptionName.internalInconsistencyException))
                    expect(exception.reason).to(equal("'afterEachAutoreleasepool' cannot be used inside 'it', 'afterEachAutoreleasepool' may only be used inside 'context' or 'describe'. "))
                })
            }
        }
#endif
    }
}

final class AutoreleasepoolTests: XCTestCase, XCTestCaseProvider {
    static var allTests: [(String, (AutoreleasepoolTests) -> () throws -> Void)] {
        return [
            ("testAutoreleasepoolClosuresOrdering", testAutoreleasepoolClosuresOrdering)
        ]
    }

    func testAutoreleasepoolClosuresOrdering() {
        executionOrder = []

        qck_runSpec(FunctionalTests_AutoreleasepoolSpec.self)
        let expectedOrder: [ExecutionOrderType] = [
            // [1] The outer autoreleasepool closures wrap beforeEach/afterEach closures.
            .outerBeforeEachAutoreleasePool, .outerBeforeEach,
            .example1,
            .outerAfterEach, .outerAfterEachAutoreleasePool,

            // [2] The nested autoreleasepool closures wrap the nested beforeEach/afterEach closures.
            .outerBeforeEachAutoreleasePool, .innerBeforeEachAutoreleasePool,
            .outerBeforeEach, .innerBeforeEach,
            .example2,
            .innerAfterEach, .outerAfterEach,
            .innerAfterEachAutoreleasePool, .outerAfterEachAutoreleasePool
        ]

        XCTAssertEqual(executionOrder, expectedOrder)
    }
}
