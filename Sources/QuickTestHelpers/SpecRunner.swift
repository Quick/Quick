@testable import Quick
import Nimble

public func qck_runSpec(specClass: QuickSpec.Type) -> TestRun {
    return qck_runSpecs([specClass])
}

public func qck_runSpecs(specClasses: [QuickSpec.Type]) -> TestRun {
    World.sharedWorld.isRunningAdditionalSuites = true

    var executionCount: UInt = 0
    var hadUnexpectedFailure = false

    let fails = gatherFailingExpectations(silently: true) {
        for specClass in specClasses {
            let spec = specClass.init()
            for (_, test) in spec.allTests {
                do {
                    try test()
                } catch {
                    hadUnexpectedFailure = true
                }
                executionCount += 1
            }
        }
    }

    return TestRun(executionCount: executionCount, hasSucceeded: fails.isEmpty && !hadUnexpectedFailure)
}
