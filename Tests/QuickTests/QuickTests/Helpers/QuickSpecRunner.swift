import Foundation
import XCTest
@testable import Quick

private func qck_runSuite(_ suite: XCTestSuite) -> XCTestRun? {
    World.sharedWorld.isRunningAdditionalSuites = true

    let result = XCTestObservationCenter.shared.qck_suspendObservation {
        suite.run()
        return suite.testRun
    }
    return result
}

/**
 Runs an XCTestSuite instance containing only the given XCTestCase subclass.
 Use this to run QuickSpec subclasses from within a set of unit tests.

 Due to implicit dependencies in _XCTFailureHandler, this function raises an
 exception when used in Swift to run a failing test case.

 @param specClass The class of the spec to be run.
 @return An XCTestRun instance that contains information such as the number of failures, etc.
 */
@discardableResult
func qck_runSpec(_ specClass: XCTest.Type) -> XCTestRun? {
    let suite = XCTestSuite(forTestCaseClass: specClass)
    return qck_runSuite(suite)
}

/**
 Runs an XCTestSuite instance containing the given XCTestCase subclasses, in the order provided.
 See the documentation for `qck_runSpec` for more details.

 @param specClasses An array of QuickSpec classes, in the order they should be run.
 @return An XCTestRun instance that contains information such as the number of failures, etc.
 */
@discardableResult
func qck_runSpecs(_ specClasses: [XCTest.Type]) -> XCTestRun? {
    let suite = XCTestSuite(name: "MySpecs")
    for specClass in specClasses {
        let test = XCTestSuite(forTestCaseClass: specClass)
        suite.addTest(test)
    }

    return qck_runSuite(suite)
}

@objc(QCKSpecRunner)
@objcMembers
class QuickSpecRunner: NSObject {
    static func runSpec(_ specClass: XCTest.Type) -> XCTestRun? {
        return qck_runSpec(specClass)
    }

    static func runSpecs(_ specClasses: [XCTest.Type]) -> XCTestRun? {
        return qck_runSpecs(specClasses)
    }
}
