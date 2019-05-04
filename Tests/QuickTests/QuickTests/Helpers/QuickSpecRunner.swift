import Foundation
import XCTest
@testable import Quick
import Nimble

#if canImport(Darwin)
typealias TestRun = XCTestRun
#else
struct TestRun {
    var executionCount: UInt
    var hasSucceeded: Bool
}
#endif

/**
 Runs an XCTestSuite instance containing only the given QuickSpec subclass.
 Use this to run QuickSpec subclasses from within a set of unit tests.

 Due to implicit dependencies in _XCTFailureHandler, this function raises an
 exception when used in Swift to run a failing test case.

 @param specClass The class of the spec to be run.
 @return An XCTestRun instance that contains information such as the number of failures, etc.
 */
@discardableResult
func qck_runSpec(_ specClass: QuickSpec.Type) -> TestRun? {
    return qck_runSpecs([specClass])
}

/**
 Runs an XCTestSuite instance containing the given QuickSpec subclasses, in the order provided.
 See the documentation for `qck_runSpec` for more details.

 @param specClasses An array of QuickSpec classes, in the order they should be run.
 @return An XCTestRun instance that contains information such as the number of failures, etc.
 */
@discardableResult
func qck_runSpecs(_ specClasses: [QuickSpec.Type]) -> TestRun? {
    #if canImport(Darwin)
    return World.anotherWorld { world -> XCTestRun? in
        QuickConfiguration.configureSubclassesIfNeeded(world: world)

        world.isRunningAdditionalSuites = true
        defer { world.isRunningAdditionalSuites = false }

        let suite = XCTestSuite(name: "MySpecs")
        for specClass in specClasses {
            let test = specClass.defaultTestSuite
            suite.addTest(test)
        }

        let result: XCTestRun? = XCTestObservationCenter.shared.qck_suspendObservation {
            suite.run()
            return suite.testRun
        }
        return result

    }
    #else
    let world = Quick.World.sharedWorld
    world.isRunningAdditionalSuites = true
    defer { world.isRunningAdditionalSuites = false }

    let result: TestRun = XCTestObservationCenter.shared.qck_suspendObservation {
        var executionCount: UInt = 0
        var hadUnexpectedFailure = false

        let fails = gatherFailingExpectations(silently: true) {
            for specClass in specClasses {
                for (_, test) in specClass.allTests {
                    do {
                        try test(specClass.init())()
                    } catch {
                        hadUnexpectedFailure = true
                    }
                    executionCount += 1
                }
            }
        }

        return TestRun(executionCount: executionCount, hasSucceeded: fails.isEmpty && !hadUnexpectedFailure)
    }
    return result
    #endif
}

#if canImport(Darwin) && !SWIFT_PACKAGE
@objc(QCKSpecRunner)
@objcMembers
class QuickSpecRunner: NSObject {
    static func runSpec(_ specClass: QuickSpec.Type) -> TestRun? {
        return qck_runSpec(specClass)
    }

    static func runSpecs(_ specClasses: [QuickSpec.Type]) -> TestRun? {
        return qck_runSpecs(specClasses)
    }
}
#endif
