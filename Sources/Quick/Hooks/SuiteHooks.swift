/**
    A container for closures to be executed before and after all examples.
*/
final internal class SuiteHooks {
    internal var befores: [BeforeSuiteClosure] = []
    internal var beforesStartedExecuting = false
    internal var beforesAlreadyExecuted = false

    internal var afters: [AfterSuiteClosure] = []
    internal var aftersStartedExecuting = false
    internal var aftersAlreadyExecuted = false

    internal func appendBefore(closure: BeforeSuiteClosure) {
        befores.append(closure)
    }

    internal func appendAfter(closure: AfterSuiteClosure) {
        afters.append(closure)
    }

    internal func executeBefores() {
        beforesStartedExecuting = true
        for before in befores {
            before()
        }
        beforesAlreadyExecuted = true
    }

    internal func executeAfters() {
        aftersStartedExecuting = true
        for after in afters {
            after()
        }
        aftersAlreadyExecuted = true
    }
}
