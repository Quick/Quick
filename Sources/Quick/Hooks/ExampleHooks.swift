/**
    A container for closures to be executed before and after each example.
*/
final internal class ExampleHooks {
    internal var befores: [BeforeExampleWithMetadataClosure] = []
    internal var afters: [AfterExampleWithMetadataClosure] = []
    internal var phase: HooksPhase = .NothingExecuted

    internal func appendBefore(closure: BeforeExampleWithMetadataClosure) {
        befores.append(closure)
    }

    internal func appendBefore(closure: BeforeExampleClosure) {
        befores.append { (exampleMetadata: ExampleMetadata) in closure() }
    }

    internal func appendAfter(closure: AfterExampleWithMetadataClosure) {
        afters.append(closure)
    }

    internal func appendAfter(closure: AfterExampleClosure) {
        afters.append { (exampleMetadata: ExampleMetadata) in closure() }
    }

    internal func executeBefores(exampleMetadata: ExampleMetadata) {
        phase = .BeforesExecuting
        for before in befores {
            before(exampleMetadata: exampleMetadata)
        }
        
        phase = .BeforesFinished
    }

    internal func executeAfters(exampleMetadata: ExampleMetadata) {
        phase = .AftersExecuting
        for after in afters {
            after(exampleMetadata: exampleMetadata)
        }

        phase = .AftersFinished
    }
}
