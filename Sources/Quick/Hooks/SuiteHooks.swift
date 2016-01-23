/**
    A container for closures to be executed before and after all examples.
*/
final internal class SuiteHooks {
    internal var befores: [BeforeSuiteClosure] = []
    internal var afters: [AfterSuiteClosure] = []
    internal var phase: HooksPhase = .NothingExecuted

    internal func appendBefore(closure: BeforeSuiteClosure) {
        befores.append(closure)
    }

    internal func appendAfter(closure: AfterSuiteClosure) {
        afters.append(closure)
    }

    internal func executeBefores() {
        phase = .BeforesExecuting
        for before in befores {
            before()
        }
        phase = .BeforesFinished
    }

    internal func executeAfters() {
        phase = .AftersExecuting
        for after in afters {
            after()
        }
        phase = .AftersFinished
    }
}
