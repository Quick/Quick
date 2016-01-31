import XCTest
import Quick
import Nimble
#if SWIFT_PACKAGE
import QuickTestHelpers
#endif

private enum BeforeEachType {
    case OuterOne
    case OuterTwo
    case InnerOne
    case InnerTwo
    case InnerThree
    case NoExamples
}

private var beforeEachOrder = [BeforeEachType]()

class FunctionalTests_BeforeEachSpec: QuickSpec {
    override func spec() {
        
        describe("beforeEach ordering") {
            beforeEach { beforeEachOrder.append(BeforeEachType.OuterOne) }
            beforeEach { beforeEachOrder.append(BeforeEachType.OuterTwo) }
            
            it("executes the outer beforeEach closures once [1]") {}
            it("executes the outer beforeEach closures a second time [2]") {}
            
            context("when there are nested beforeEach") {
                beforeEach { beforeEachOrder.append(BeforeEachType.InnerOne) }
                beforeEach { beforeEachOrder.append(BeforeEachType.InnerTwo) }
                beforeEach { beforeEachOrder.append(BeforeEachType.InnerThree) }
                
                it("executes the outer and inner beforeEach closures [3]") {}
            }
            
            context("when there are nested beforeEach without examples") {
                beforeEach { beforeEachOrder.append(BeforeEachType.NoExamples) }
            }
        }
#if _runtime(_ObjC)
        describe("error handling when misusing ordering") {
            it("should throw an exception when including beforeEach in it block") {
                expect {
                    beforeEach { }
                    }.to(raiseException { (exception: NSException) in
                        expect(exception.name).to(equal(NSInternalInconsistencyException))
                        expect(exception.reason).to(equal("'beforeEach' cannot be used inside 'it', 'beforeEach' may only be used inside 'context' or 'describe'. "))
                        })
            }
        }
#endif
    }
}

class BeforeEachTests: XCTestCase, XCTestCaseProvider {
    var allTests: [(String, () throws -> Void)] {
        return [
            ("testBeforeEachIsExecutedInTheCorrectOrder", testBeforeEachIsExecutedInTheCorrectOrder),
        ]
    }

    func testBeforeEachIsExecutedInTheCorrectOrder() {
        beforeEachOrder = []

        qck_runSpec(FunctionalTests_BeforeEachSpec.self)
        let expectedOrder = [
            // [1] The outer beforeEach closures are executed from top to bottom.
            BeforeEachType.OuterOne, BeforeEachType.OuterTwo,
            // [2] The outer beforeEach closures are executed from top to bottom.
            BeforeEachType.OuterOne, BeforeEachType.OuterTwo,
            // [3] The outer beforeEach closures are executed from top to bottom,
            //     then the inner beforeEach closures are executed from top to bottom.
            BeforeEachType.OuterOne, BeforeEachType.OuterTwo,
                BeforeEachType.InnerOne, BeforeEachType.InnerTwo, BeforeEachType.InnerThree,
        ]
        XCTAssertEqual(beforeEachOrder, expectedOrder)
    }
}
