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

    /// Synchronous version of aroundEach, passing in metadata to the closure.
    /// Warning: This should only be used for objective-c compatibility.
    internal func appendAroundSync(_ closure: @escaping AroundExampleWithMetadataClosure) {
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
    internal func appendAroundSync(_ closure: @escaping AroundExampleClosure) {
        wrappers.append { _, runExample in
            closure {
                let expectation = QuickSpec.current.expectation(description: "Objective-C/Swift Concurrency Compatibility")
                Task {
                    await runExample()
                    expectation.fulfill()
                }
                QuickSpec.current.wait(for: [expectation], timeout: asyncTestTimeout)
            }
        }
    }
}

extension Array {
    mutating func prepend(_ element: Element) {
        insert(element, at: 0)
    }
}

// This is the same length of timeout that XCTest uses internally for awaiting their async tests.
// See https://github.com/apple/swift-corelibs-xctest/tree/main/Sources/XCTest/Public/XCTestCase.swift#L375-L378
private let asyncTestTimeout: TimeInterval = 60 * 60 * 24 * 30
