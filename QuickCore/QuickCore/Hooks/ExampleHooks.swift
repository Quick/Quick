/**
    A container for closures to be executed before and after each example.
*/
final public class ExampleHooks {

    internal var befores: [BeforeExampleWithMetadataClosure] = []
    internal var afters: [AfterExampleWithMetadataClosure] = []

    public func appendBefore(closure: BeforeExampleWithMetadataClosure) {
        befores.append(closure)
    }

    public func appendBefore(closure: BeforeExampleClosure) {
        befores.append { (exampleMetadata: ExampleMetadata) in closure() }
    }

    public func appendAfter(closure: AfterExampleWithMetadataClosure) {
        afters.append(closure)
    }

    public func appendAfter(closure: AfterExampleClosure) {
        afters.append { (exampleMetadata: ExampleMetadata) in closure() }
    }

    internal func executeBefores(exampleMetadata: ExampleMetadata) {
        for before in befores {
            before(exampleMetadata: exampleMetadata)
        }
    }

    internal func executeAfters(exampleMetadata: ExampleMetadata) {
        for after in afters {
            after(exampleMetadata: exampleMetadata)
        }
    }
}
