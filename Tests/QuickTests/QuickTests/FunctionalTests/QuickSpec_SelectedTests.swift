#if canImport(Darwin) && !SWIFT_PACKAGE

import Nimble
@testable import Quick
import XCTest

// The regression tests for https://github.com/Quick/Quick/issues/891

class SimulateSelectedTests_TestCase: QuickSpec {
    override class var defaultTestSuite: QuickTestSuite {
        // XCTest doesn't call `defaultTestSuite` when running only selected tests.
        // We simulate this behavior by not calling super.
        return .init(name: "Selected tests")
    }

    override func spec() {
        it("example1") { }
        it("example2") { }
        it("example3") { }
    }
}

class SimulateAllTests_TestCase: QuickSpec {
    override func spec() {
        it("example1") { }
        it("example2") { }
        it("example3") { }
    }
}

class QuickSpec_SelectedTests: XCTestCase {

    func testQuickSpecTestInvocationsForAllTests() {
        // Simulate running 'All tests'
        let invocations = SimulateAllTests_TestCase.testInvocations
        expect(invocations).to(haveCount(3))

        let selectorNames = invocations.map { $0.selector.description }
        expect(selectorNames).to(contain(["example1:", "example2:", "example3:"]))
    }

    func testQuickSpecTestInvocationsForSelectedTests() {
        // Simulate running 'Selected tests'
        let invocations = SimulateSelectedTests_TestCase.testInvocations
        expect(invocations).to(haveCount(3))

        let selectorNames = invocations.map { $0.selector.description }
        expect(selectorNames).to(contain(["example1:", "example2:", "example3:"]))
    }

    func testQuickSpecRequestingNoTestCase() {
        QuickTestSuite.reset()

        let suite = XCTestSuite(forTestCaseWithName: "SimulateSelectedTests_TestCase")
        expect(suite.tests).to(haveCount(3))
    }

    func testQuickSpecRequestingOneTestCase() {
        QuickTestSuite.reset()

        let suite = XCTestSuite(forTestCaseWithName: "SimulateSelectedTests_TestCase/example1:")
        expect(suite.tests).to(haveCount(1))
        expect(suite.tests).to(allPass { $0.name.contains("example1:") == true })
    }
}

#endif
