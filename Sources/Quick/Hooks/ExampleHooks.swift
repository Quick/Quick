/**
    A container for closures to be executed before and after each example.
*/
final internal class ExampleHooks {
    internal var wrappers: [AroundExampleWithMetadataClosure] = []
    internal var phase: HooksPhase = .nothingExecuted

    internal func appendBefore(_ closure: @escaping BeforeExampleWithMetadataClosure) {
        wrappers.append { exampleMetadata, runExample in
            closure(exampleMetadata)
            runExample()
        }
    }

    internal func appendBefore(_ closure: @escaping BeforeExampleClosure) {
        wrappers.append { _, runExample in
            closure()
            runExample()
        }
    }

    internal func appendAfter(_ closure: @escaping AfterExampleWithMetadataClosure) {
        wrappers.prepend { exampleMetadata, runExample in
            runExample()
            closure(exampleMetadata)
        }
    }

    internal func appendAfter(_ closure: @escaping AfterExampleClosure) {
        wrappers.prepend { _, runExample in
            runExample()
            closure()
        }
    }

    internal func appendAround(_ closure: @escaping AroundExampleWithMetadataClosure) {
        wrappers.append(closure)
    }

    internal func appendAround(_ closure: @escaping AroundExampleClosure) {
        wrappers.append { _, runExample in closure(runExample) }
    }
}

extension Array {
    mutating func prepend(_ element: Element) {
        insert(element, at: 0)
    }
}
