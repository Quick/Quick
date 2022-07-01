/**
    A container for closures to be executed before and after each example.
*/
final internal class ExampleHooks {
    internal var justBeforeEachStatements: [AroundExampleWithMetadataClosure] = []
    internal var wrappers: [AroundExampleWithMetadataClosure] = []
    internal var phase: HooksPhase = .nothingExecuted

    internal func appendJustBeforeEach(_ closure: @escaping BeforeExampleClosure) {
        justBeforeEachStatements.append { _, runExample in
            await closure()
            await runExample()
        }
    }

    internal func appendBefore(_ closure: @escaping BeforeExampleWithMetadataClosure) {
        wrappers.append { exampleMetadata, runExample in
            await closure(exampleMetadata)
            await runExample()
        }
    }

    internal func appendBefore(_ closure: @escaping BeforeExampleClosure) {
        wrappers.append { _, runExample in
            await closure()
            await runExample()
        }
    }

    internal func appendAfter(_ closure: @escaping AfterExampleWithMetadataClosure) {
        wrappers.prepend { exampleMetadata, runExample in
            await runExample()
            await closure(exampleMetadata)
        }
    }

    internal func appendAfter(_ closure: @escaping AfterExampleClosure) {
        wrappers.prepend { _, runExample in
            await runExample()
            await closure()
        }
    }

    internal func appendAround(_ closure: @escaping AroundExampleWithMetadataClosure) {
        wrappers.append(closure)
    }

    internal func appendAround(_ closure: @escaping AroundExampleClosure) {
        wrappers.append { _, runExample in await closure(runExample) }
    }

    /// Synchronous version of aroundEach, passing in metadata to the closure.
    /// Warning: This should only be used for objective-c compatibility.
    internal func appendAroundSync(_ closure: @escaping AroundExampleWithMetadataSyncClosure) {
        wrappers.append { exampleMetadata, runExample in
            closure(exampleMetadata) {
                let expectation = QuickSpec.current.expectation(description: "Objective-C/Swift Concurrency Compatibility")
                Task {
                    await runExample()
                    expectation.fulfill()
                }
                QuickSpec.current.wait(for: [expectation], timeout: 1)
            }
        }
    }

    /// Synchronous version of aroundEach.
    /// Warning: This should only be used for objective-c compatibility.
    internal func appendAroundSync(_ closure: @escaping AroundExampleSyncClosure) {
        wrappers.append { _, runExample in
            closure {
                let expectation = QuickSpec.current.expectation(description: "Objective-C/Swift Concurrency Compatibility")
                Task {
                    await runExample()
                    expectation.fulfill()
                }
                QuickSpec.current.wait(for: [expectation], timeout: 1)
            }
        }
    }
}

extension Array {
    mutating func prepend(_ element: Element) {
        insert(element, at: 0)
    }
}
