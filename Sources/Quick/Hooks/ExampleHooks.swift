/**
    A container for closures to be executed before and after each example.
*/
final internal class ExampleHooks {
    internal var befores: [BeforeExampleWithMetadataClosure] = []
    internal var afters: [AfterExampleWithMetadataClosure] = []
    internal var autoreleasepoolBefores: [BeforeExampleWithMetadataClosure] = []
    internal var autoreleasepoolAfters: [AfterExampleWithMetadataClosure] = []
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

    internal func appendBeforeAutoreleasepool(_ closure: @escaping BeforeExampleWithMetadataClosure) {
        autoreleasepoolBefores.append(closure)
    }

    internal func appendBeforeAutoreleasepool(_ closure: @escaping BeforeExampleClosure) {
        autoreleasepoolBefores.append { (_: ExampleMetadata) in closure() }
    }

    internal func appendAfterAutoreleasepool(_ closure: @escaping AfterExampleWithMetadataClosure) {
        autoreleasepoolAfters.append(closure)
    }

    internal func appendAfterAutoreleasepool(_ closure: @escaping AfterExampleClosure) {
        autoreleasepoolAfters.append { (_: ExampleMetadata) in closure() }
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
