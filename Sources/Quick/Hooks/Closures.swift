// MARK: Example Hooks

/**
    An async closure executed on the main actor before an example is run.
*/
public typealias BeforeExampleAsyncClosure = @MainActor () async -> Void

/**
    A closure executed before an example is run.
    Synchronous version for legacy and Objc support.
 */
public typealias BeforeExampleClosure = () -> Void

/**
    An async closure executed on the main actor before an example is run. The closure is given example metadata,
    which contains information about the example that is about to be run.
*/
public typealias BeforeExampleWithMetadataAsyncClosure = @MainActor (_ exampleMetadata: ExampleMetadata) async -> Void

/**
    A closure executed before an example is run. The closure is given example metadata,
    which contains information about the example that is about to be run.
    Synchronus version for legacy and Objc support.
 */
public typealias BeforeExampleWithMetadataClosure = (_ exampleMetadata: ExampleMetadata) -> Void

/**
    An async closure executed on the main actor after an example is run.
*/
public typealias AfterExampleAsyncClosure = BeforeExampleAsyncClosure

/**
    A closure executed after an example is run.
    Synchronous version for legacy and Objc support.
*/
public typealias AfterExampleClosure = BeforeExampleClosure

/**
    An closure executed on the main actor after an example is run. The closure is given example metadata,
    which contains information about the example that has just finished running.
*/
public typealias AfterExampleWithMetadataAsyncClosure = BeforeExampleWithMetadataAsyncClosure

/**
    A closure executed after an example is run. The closure is given example metadata,
    which contains information about the example that has just finished running.
    Synchronous version for legacy and Objc support.
*/
public typealias AfterExampleWithMetadataClosure = BeforeExampleWithMetadataClosure

/**
    An async closure executed on the main actor which wraps an example. The closure must call runExample() exactly once.

    Both the closure and runExample will be executed on the main actor.
*/
public typealias AroundExampleAsyncClosure = @MainActor (_ runExample: @escaping @MainActor () async -> Void) async -> Void

/**
    A closure which wraps an example. The closure must call runExample() exactly once.
    Synchronous version for legacy and Objc support.
*/
public typealias AroundExampleClosure = (_ runExample: @escaping () -> Void) -> Void

/**
    An async closure executed on the main actor which wraps an example. The closure is given example metadata,
    which contains information about the example that the wrapper will run.
    The closure must call runExample() exactly once.
    Both the closure and runExample will be executed on the main actor.
*/
public typealias AroundExampleWithMetadataAsyncClosure =
    @MainActor (_ exampleMetadata: ExampleMetadata, _ runExample: @escaping @MainActor () async -> Void) async -> Void

/**
    A closure which wraps an example. The closure is given example metadata,
    which contains information about the example that the wrapper will run.
    The closure must call runExample() exactly once.
 
    Synchronous version for legacy and Objc support.
*/
public typealias AroundExampleWithMetadataClosure =
(_ exampleMetadata: ExampleMetadata, _ runExample: @escaping () -> Void) -> Void

// MARK: Suite Hooks

/**
    An closure executed on the main actor before any examples are run.
*/
public typealias BeforeSuiteAsyncClosure = @MainActor () async -> Void

/**
    A closure executed before any examples are run.
    Synchronous version for Objc support.
*/
public typealias BeforeSuiteClosure = () -> Void

/**
    A closure executed after all examples have finished running.
*/
public typealias AfterSuiteAsyncClosure = BeforeSuiteAsyncClosure

/**
    A closure executed after all examples have finished running.
    Synchronous version for Objc support.
*/
public typealias AfterSuiteClosure = BeforeSuiteClosure
