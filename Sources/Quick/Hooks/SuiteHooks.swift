/**
    A container for closures to be executed before and after all examples.
*/
final internal class SuiteHooks {
    internal var befores: [BeforeSuiteAsyncClosure] = []
    internal var afters: [AfterSuiteAsyncClosure] = []
    internal var phase: HooksPhase = .nothingExecuted

    internal func appendBefore(_ closure: @escaping BeforeSuiteAsyncClosure) {
        befores.append(closure)
    }

    internal func appendBefore(_ closure: @escaping BeforeSuiteClosure) {
        befores.append(closure)
    }

    internal func appendAfter(_ closure: @escaping AfterSuiteAsyncClosure) {
        afters.append(closure)
    }

    internal func executeBefores() async {
        phase = .beforesExecuting
        for before in befores {
            await before()
        }
        phase = .beforesFinished
    }

    internal func executeAfters() async {
        phase = .aftersExecuting
        for after in afters {
            await after()
        }
        phase = .aftersFinished
    }
}
