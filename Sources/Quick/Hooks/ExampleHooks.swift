import Foundation

/**
    A container for closures to be executed before and after each example.
*/
final internal class ExampleHooks {
    internal var justBeforeEachStatements: [AroundExampleWithMetadataAsyncClosure] = []
    internal var wrappers: [AroundExampleWithMetadataAsyncClosure] = []
    internal var phase: HooksPhase = .nothingExecuted

    internal func appendJustBeforeEach(_ closure: @escaping BeforeExampleAsyncClosure) {
        justBeforeEachStatements.append { _, runExample in
            await closure()
            await runExample()
        }
    }

    internal func appendBefore(_ closure: @escaping BeforeExampleWithMetadataAsyncClosure) {
        wrappers.append { exampleMetadata, runExample in
            await closure(exampleMetadata)
            await runExample()
        }
    }

    internal func appendBefore(_ closure: @escaping BeforeExampleAsyncClosure) {
        wrappers.append { _, runExample in
            await closure()
            await runExample()
        }
    }

    internal func appendAfter(_ closure: @escaping AfterExampleWithMetadataAsyncClosure) {
        wrappers.prepend { exampleMetadata, runExample in
            await runExample()
            await closure(exampleMetadata)
        }
    }

    internal func appendAfter(_ closure: @escaping AfterExampleAsyncClosure) {
        wrappers.prepend { _, runExample in
            await runExample()
            await closure()
        }
    }

    internal func appendAround(_ closure: @escaping AroundExampleWithMetadataAsyncClosure) {
        wrappers.append(closure)
    }

    internal func appendAround(_ closure: @escaping AroundExampleAsyncClosure) {
        wrappers.append { _, runExample in await closure(runExample) }
    }
}

extension Array {
    mutating func prepend(_ element: Element) {
        insert(element, at: 0)
    }
}
