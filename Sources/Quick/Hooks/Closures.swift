// MARK: Example Hooks

/**
    An async closure executed before an example is run.
*/
public typealias BeforeExampleAsyncClosure = () async -> Void

/**
    A closure executed before an example is run.
    Synchronous version for Objc support.
 */
public typealias BeforeExampleClosure = @MainActor () -> Void

/**
    An async closure executed before an example is run. The closure is given example metadata,
    which contains information about the example that is about to be run.
*/
public typealias BeforeExampleWithMetadataAsyncClosure = (_ exampleMetadata: ExampleMetadata) async -> Void

/**
    A closure executed before an example is run. The closure is given example metadata,
    which contains information about the example that is about to be run.
    Synchronus version for Objc support.
 */
public typealias BeforeExampleWithMetadataClosure = @MainActor (_ exampleMetadata: ExampleMetadata) -> Void

/**
    An async closure executed after an example is run.
*/
public typealias AfterExampleAsyncClosure = BeforeExampleAsyncClosure

/**
    A closure executed after an example is run.
    Synchronous version for Objc support.
*/
public typealias AfterExampleClosure = BeforeExampleClosure

/**
    An closure executed after an example is run. The closure is given example metadata,
    which contains information about the example that has just finished running.
*/
public typealias AfterExampleWithMetadataAsyncClosure = BeforeExampleWithMetadataAsyncClosure

/**
    A closure executed after an example is run. The closure is given example metadata,
    which contains information about the example that has just finished running.
    Synchronous version for Objc support.
*/
public typealias AfterExampleWithMetadataClosure = BeforeExampleWithMetadataClosure

/**
    An async closure which wraps an example. The closure must call runExample() exactly once.
*/
public typealias AroundExampleAsyncClosure = (_ runExample: @escaping () async -> Void) async -> Void

/**
    An async closure which wraps an example. The closure is given example metadata,
    which contains information about the example that the wrapper will run.
    The closure must call runExample() exactly once.
*/
public typealias AroundExampleWithMetadataAsyncClosure =
    (_ exampleMetadata: ExampleMetadata, _ runExample: @escaping () async -> Void) async -> Void

// MARK: Suite Hooks

/**
    An closure executed before any examples are run.
*/
public typealias BeforeSuiteAsyncClosure = () async -> Void

/**
    A closure executed before any examples are run.
    Synchronous version for Objc support.
*/
public typealias BeforeSuiteClosure = @MainActor () -> Void

/**
    A closure executed after all examples have finished running.
*/
public typealias AfterSuiteAsyncClosure = BeforeSuiteAsyncClosure

/**
    A closure executed after all examples have finished running.
    Synchronous version for Objc support.
*/
public typealias AfterSuiteClosure = BeforeSuiteClosure
