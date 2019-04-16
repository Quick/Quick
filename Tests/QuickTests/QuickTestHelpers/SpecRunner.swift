@testable import Quick
import Nimble

@discardableResult
func qck_runSpec(_ specClass: QuickSpec.Type) -> TestRun? {
    return qck_runSpecs([specClass])
}

@discardableResult
func qck_runSpecs(_ specClasses: [QuickSpec.Type]) -> TestRun? {
    Quick.World.sharedWorld.isRunningAdditionalSuites = true
    defer { Quick.World.sharedWorld.isRunningAdditionalSuites = false }

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
