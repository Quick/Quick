/**
    A container for closures to be executed before and after each example.
*/
final internal class ExampleHooks {

    internal var befores: [BeforeExampleWithMetadataClosure] = []
    internal var beforesStartedExecuting = false
    internal var beforesAlreadyExecuted = false

    internal var afters: [AfterExampleWithMetadataClosure] = []
    internal var aftersStartedExecuting = false
    internal var aftersAlreadyExecuted = false

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
        beforesStartedExecuting = true
        for before in befores {
            before(exampleMetadata: exampleMetadata)
        }
        
        beforesAlreadyExecuted = true
    }

    internal func executeAfters(exampleMetadata: ExampleMetadata) {
        aftersStartedExecuting = true
        for after in afters {
            after(exampleMetadata: exampleMetadata)
        }
        
        aftersAlreadyExecuted = true
    }
}
