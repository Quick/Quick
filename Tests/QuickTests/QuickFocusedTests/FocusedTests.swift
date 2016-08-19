import Quick
import Nimble
import XCTest

class FunctionalTests_FocusedSpec_SharedExamplesConfiguration: QuickConfiguration {
    override class func configure(_ configuration: Configuration) {
        sharedExamples("two passing shared examples") {
            it("has an example that passes (4)") {}
            it("has another example that passes (5)") {}
        }
    }
}

class FunctionalTests_FocusedSpec_Focused: QuickSpec {
    override func spec() {
        it("has an unfocused example that fails, but is never run") { fail() }
        fit("has a focused example that passes (1)") {}

        fdescribe("a focused example group") {
            it("has an example that is not focused, but will be run, and passes (2)") {}
            fit("has a focused example that passes (3)") {}
        }

        // TODO: Port fitBehavesLike to Swift.
        itBehavesLike("two passing shared examples", flags: [Filter.focused: true])
    }
}

class FunctionalTests_FocusedSpec_Unfocused: QuickSpec {
    override func spec() {
        it("has an unfocused example that fails, but is never run") { fail() }

        describe("an unfocused example group that is never run") {
            beforeEach { assert(false) }
            it("has an example that fails, but is never run") { fail() }
        }
    }
}

final class FocusedTests: XCTestCase, XCTestCaseProvider {
    static var allTests: [(String, (FocusedTests) -> () throws -> Void)] {
        return [
            ("testOnlyFocusedExamplesAreExecuted", testOnlyFocusedExamplesAreExecuted),
        ]
    }

    func testOnlyFocusedExamplesAreExecuted() {
        let result = qck_runSpecs([
            FunctionalTests_FocusedSpec_Focused.self,
            FunctionalTests_FocusedSpec_Unfocused.self
        ])
        XCTAssertEqual(result?.executionCount, 5 as UInt)
    }
}
