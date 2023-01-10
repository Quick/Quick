import XCTest
@testable import Quick

@discardableResult
func runAsyncSpec(_ specClass: AsyncSpec.Type) -> XCTestRun? {
    let suite = XCTestSuite(name: "Testing AsyncSpec")
    suite.addTest(specClass.defaultTestSuite)
    return XCTestObservationCenter.shared.qck_suspendObservation {
        suite.run()
        return suite.testRun
    }
}
