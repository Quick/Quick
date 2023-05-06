import Quick
import Nimble
import XCTest

class FunctionalTests_FocusedAsyncSpec_AsyncBehavior: AsyncBehavior<Void> {
    override static func spec(_ aContext: @escaping () -> Void) {
        it("pass once") { expect(true).to(beTruthy()) }
        it("pass twice") { expect(true).to(beTruthy()) }
        it("pass three times") { expect(true).to(beTruthy()) }
    }
}

// The following `QuickSpec`s will be run in a same test suite with other specs
// on SwiftPM. We must avoid that the focused flags below affect other specs, so
// the examples of the two specs must be gathered lastly. That is the reason why
// the two specs have underscore prefix (and are listed at the bottom of `QCKMain`s
// `specs` array).

class _FunctionalTests_FocusedAsyncSpec_Focused: AsyncSpec {
    override class func spec() {
        it("has an unfocused example that fails, but is never run") { fail() }
        fit("has a focused example that passes (1)") {}

        fdescribe("a focused example group") {
            it("has an example that is not focused, but will be run, and passes (2)") {}
            fit("has a focused example that passes (3)") {}
        }

        fitBehavesLike(FunctionalTests_FocusedAsyncSpec_AsyncBehavior.self) { () -> Void in }
    }
}

class _FunctionalTests_FocusedAsyncSpec_Unfocused: AsyncSpec {
    override class func spec() {
        it("has an unfocused example that fails, but is never run") { fail() }

        describe("an unfocused example group that is never run") {
            beforeEach { assert(false) }
            it("has an example that fails, but is never run") { fail() }
        }
    }
}

final class FocusedAsyncTests: XCTestCase, XCTestCaseProvider {
    static var allTests: [(String, (FocusedAsyncTests) -> () throws -> Void)] {
        return [
            ("testOnlyFocusedExamplesAreExecuted", testOnlyFocusedExamplesAreExecuted),
        ]
    }

    func testOnlyFocusedExamplesAreExecuted() {
        #if SWIFT_PACKAGE
        let result = qck_runSpecs([
            _FunctionalTests_FocusedSpec_Focused.self,
            _FunctionalTests_FocusedSpec_Unfocused.self,
        ])
        #else
        let result = qck_runSpecs([
            _FunctionalTests_FocusedSpec_Unfocused.self,
            _FunctionalTests_FocusedSpec_Focused.self,
        ])
        #endif
        XCTAssertEqual(result?.executionCount, 8)
    }
}
