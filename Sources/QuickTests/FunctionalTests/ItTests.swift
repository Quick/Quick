import XCTest
import Quick
import Nimble
#if SWIFT_PACKAGE
import QuickTestHelpers
#endif

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
        
#if _runtime(_ObjC)
        describe("error handling when misusing ordering") {
            it("an it") {
                expect {
                    it("will throw an error when it is nested in another it") { }
                    }.to(raiseException { (exception: NSException) in
                        expect(exception.name).to(equal(NSInternalInconsistencyException))
                        expect(exception.reason).to(equal("'it' cannot be used inside 'it', 'it' may only be used inside 'context' or 'describe'. "))
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
                    expect(exception!.reason).to(equal("'it' cannot be used inside 'beforeEach', 'it' may only be used inside 'context' or 'describe'. "))
                }
            }
            
            describe("behavior with an 'it' inside an 'afterEach'") {
                var exception: NSException?
                
                afterEach {
                    let capture = NMBExceptionCapture(handler: ({ e in
                        exception = e
                        expect(exception).toNot(beNil())
                        expect(exception!.reason).to(equal("'it' cannot be used inside 'afterEach', 'it' may only be used inside 'context' or 'describe'. "))
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
    }
}

class ItTests: XCTestCase, XCTestCaseProvider {
    var allTests: [(String, () -> Void)] {
        return [
            ("testAllExamplesAreExecuted", testAllExamplesAreExecuted),
        ]
    }

#if _runtime(_ObjC)
    func testAllExamplesAreExecuted() {
        let result = qck_runSpec(FunctionalTests_ItSpec.self)
        XCTAssertEqual(result.executionCount, 5 as UInt)
    }
#else
    func testAllExamplesAreExecuted() {
        let result = qck_runSpec(FunctionalTests_ItSpec.self)
        XCTAssertEqual(result.executionCount, 2 as UInt)
    }
#endif
}
