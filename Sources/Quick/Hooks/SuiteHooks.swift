/**
    A container for closures to be executed before and after all examples.
*/
final internal class SuiteHooks {
    internal var befores: [BeforeSuiteClosure] = []
    internal var afters: [AfterSuiteClosure] = []
    internal var phase: HooksPhase = .nothingExecuted

    internal func appendBefore(_ closure: @escaping BeforeSuiteClosure) {
        befores.append(closure)
    }

    internal func appendAfter(_ closure: @escaping AfterSuiteClosure) {
        afters.append(closure)
    }

    @MainActor
    internal func executeBefores() {
        phase = .beforesExecuting
        for before in befores {
            do {
                try before()
            } catch {
                break
            }
        }
        phase = .beforesFinished
    }

    @MainActor
    internal func executeAfters() {
        phase = .aftersExecuting
        for after in afters {
            do {
                try after()
            } catch {
                break
            }
        }
        phase = .aftersFinished
    }
}
