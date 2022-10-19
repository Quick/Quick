import XCTest
import Quick
import Nimble

private enum AroundEachType {
    case around0Prefix
    case around0Suffix
    case around1Prefix
    case around1Suffix
    case before0
    case before1
    case before2
    case after0
    case after1
    case after2
    case innerBefore
    case innerAfter
    case innerAroundPrefix
    case innerAroundSuffix
}

private var aroundEachOrder = [AroundEachType]()

class FunctionalTests_AroundEachSpec: QuickSpec {
    override func spec() {
        describe("aroundEach ordering") {
            beforeEach { aroundEachOrder.append(.before0) }
            afterEach { aroundEachOrder.append(.after0) }
            aroundEach { run in
                aroundEachOrder.append(.around0Prefix)
                await run()
                aroundEachOrder.append(.around0Suffix)
            }
            beforeEach { aroundEachOrder.append(.before1) }
            afterEach { aroundEachOrder.append(.after1) }
            aroundEach { run in
                aroundEachOrder.append(.around1Prefix)
                await run()
                aroundEachOrder.append(.around1Suffix)
            }
            beforeEach { aroundEachOrder.append(.before2) }
            afterEach { aroundEachOrder.append(.after2) }

            it("executes the prefix portion before each example, but not the suffix portion [1]") {
                expect(aroundEachOrder).to(equal([
                    .before0, .around0Prefix,
                    .before1, .around1Prefix,
                    .before2,
                ]))
            }

            context("when there are nested aroundEach") {
                beforeEach { aroundEachOrder.append(.innerBefore) }
                afterEach { aroundEachOrder.append(.innerAfter) }
                aroundEach { run in
                    aroundEachOrder.append(.innerAroundPrefix)
                    await run()
                    aroundEachOrder.append(.innerAroundSuffix)
                }

                it("executes the outer and inner aroundEach closures, but not before this closure [2]") {
                    expect(aroundEachOrder).to(contain(.innerAroundPrefix, .innerBefore))
                    expect(aroundEachOrder).notTo(contain(.innerAroundSuffix))
                    expect(aroundEachOrder).notTo(contain(.innerAfter))
                }
            }
        }

        describe("execution threads") {
            aroundEach { run in
                expect(Thread.isMainThread).to(beFalse())
                await run()
            }

            it("runs on the main thread") {
                expect(Thread.isMainThread).to(beFalse())
            }
        }

#if canImport(Darwin) && !SWIFT_PACKAGE
        describe("error handling when misusing ordering") {
            it("should throw an exception when including aroundEach in it block") {
                expect {
                    aroundEach { _ in }
                }.to(raiseException { (exception: NSException) in
                    expect(exception.name).to(equal(NSExceptionName.internalInconsistencyException))
                    expect(exception.reason).to(equal("'aroundEach' cannot be used inside 'it', 'aroundEach' may only be used inside 'context' or 'describe'. "))
                })
            }
        }
#endif
    }
}

final class AroundEachTests: XCTestCase, XCTestCaseProvider {
    static var allTests: [(String, (AroundEachTests) -> () throws -> Void)] {
        return [
            ("testAroundEachIsExecutedInTheCorrectOrder", testAroundEachIsExecutedInTheCorrectOrder),
        ]
    }

    func testAroundEachIsExecutedInTheCorrectOrder() {
        aroundEachOrder = []

        qck_runSpec(FunctionalTests_AroundEachSpec.self)
        let expectedOrder: [AroundEachType] = [
            // First spec [1]
            .before0, .around0Prefix,  // All beforeEaches and aroundEach prefixes happen in order...
            .before1, .around1Prefix,
            .before2,
            .around1Suffix,            // ...then aroundEaches suffixes resolve in order...
            .around0Suffix,
            .after0, .after1, .after2, // ...then afterEaches all come last.

            .before0, .around0Prefix,          // Outer setup happens first...
            .before1, .around1Prefix,
            .before2,
            .innerBefore, .innerAroundPrefix,  // ...then inner setup...
            .innerAroundSuffix, .innerAfter,   // ...then inner cleanup, happily inner after...
            .around1Suffix,                    // ...then the outer cleanup, as before.
            .around0Suffix,
            .after0, .after1, .after2,
        ]
        XCTAssertEqual(aroundEachOrder, expectedOrder)

        aroundEachOrder = []
    }
}
