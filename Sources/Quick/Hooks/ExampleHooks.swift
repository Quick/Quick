/**
    A container for closures to be executed before and after each example.
*/
final internal class ExampleHooks {
    internal var befores: [BeforeExampleWithMetadataClosure] = []
    internal var afters: [AfterExampleWithMetadataClosure] = []
    internal var arounds: [AroundExampleWithMetadataClosure] = []
    internal var phase: HooksPhase = .nothingExecuted

    internal func appendBefore(_ closure: @escaping BeforeExampleWithMetadataClosure) {
        befores.append(closure)
    }

    internal func appendBefore(_ closure: @escaping BeforeExampleClosure) {
        befores.append { (_: ExampleMetadata) in closure() }
    }

    internal func appendAfter(_ closure: @escaping AfterExampleWithMetadataClosure) {
        afters.append(closure)
    }

    internal func appendAfter(_ closure: @escaping AfterExampleClosure) {
        afters.append { (_: ExampleMetadata) in closure() }
    }

    internal func appendAround(_ closure: @escaping AroundExampleWithMetadataClosure) {
        arounds.append(closure)
    }

    internal func appendAround(_ closure: @escaping AroundExampleClosure) {
        arounds.append { (_: ExampleMetadata, runExample: () -> Void) in closure(runExample) }
    }

    internal func executeBefores(_ exampleMetadata: ExampleMetadata) {
        phase = .beforesExecuting
        for before in befores {
            before(exampleMetadata)
        }

        phase = .beforesFinished
    }

    internal func executeAfters(_ exampleMetadata: ExampleMetadata) {
        phase = .aftersExecuting
        for after in afters {
            after(exampleMetadata)
        }

        phase = .aftersFinished
    }
}
