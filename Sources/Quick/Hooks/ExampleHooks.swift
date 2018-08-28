/**
    A container for closures to be executed before and after each example.
*/
final internal class ExampleHooks {
    internal var arounds: [AroundExampleWithMetadataClosure] = []
    internal var phase: HooksPhase = .nothingExecuted

    internal func appendBefore(_ closure: @escaping BeforeExampleWithMetadataClosure) {
        arounds.append { exampleMetadata, runExample in
            closure(exampleMetadata)
            runExample()
        }
    }

    internal func appendBefore(_ closure: @escaping BeforeExampleClosure) {
        arounds.append { exampleMetadata, runExample in
            closure()
            runExample()
        }
    }

    internal func appendAfter(_ closure: @escaping AfterExampleWithMetadataClosure) {
        arounds.prepend { exampleMetadata, runExample in
            runExample()
            closure(exampleMetadata)
        }
    }

    internal func appendAfter(_ closure: @escaping AfterExampleClosure) {
        arounds.prepend { exampleMetadata, runExample in
            runExample()
            closure()
        }
    }

    internal func appendAround(_ closure: @escaping AroundExampleWithMetadataClosure) {
        arounds.append(closure)
    }

    internal func appendAround(_ closure: @escaping AroundExampleClosure) {
        arounds.append { _, runExample in closure(runExample) }
    }
}

extension Array {
    mutating func prepend(_ element: Element) {
        insert(element, at: 0)
    }
}
