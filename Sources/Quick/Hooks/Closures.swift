// MARK: Example Hooks

/**
    A closure executed before an example is run.
*/
public typealias BeforeExampleAsyncClosure = @Sendable () async -> Void

/**
    A closure executed before an example is run.
    Synchronous version for legacy and Objc support.
 */
public typealias BeforeExampleClosure = @Sendable () -> Void

/**
    A closure executed before an example is run. The closure is given example metadata,
    which contains information about the example that is about to be run.
*/
public typealias BeforeExampleWithMetadataAsyncClosure = @Sendable (_ exampleMetadata: ExampleMetadata) async -> Void

/**
    A closure executed before an example is run. The closure is given example metadata,
    which contains information about the example that is about to be run.
    Synchronus version for legacy and Objc support.
 */
public typealias BeforeExampleWithMetadataClosure = @Sendable (_ exampleMetadata: ExampleMetadata) -> Void

/**
    A closure executed after an example is run.
*/
public typealias AfterExampleAsyncClosure = BeforeExampleAsyncClosure

/**
    A closure executed after an example is run.
    Synchronous version for legacy and Objc support.
*/
public typealias AfterExampleClosure = BeforeExampleClosure

/**
    A closure executed after an example is run. The closure is given example metadata,
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
    A closure which wraps an example. The closure must call runExample() exactly once.
*/
public typealias AroundExampleAsyncClosure = @Sendable (_ runExample: @Sendable @escaping () async -> Void) async -> Void

/**
    A closure which wraps an example. The closure must call runExample() exactly once.
    Synchronous version for legacy and Objc support.
*/
public typealias AroundExampleClosure = @Sendable (_ runExample: @Sendable @escaping () -> Void) -> Void

/**
    A closure which wraps an example. The closure is given example metadata,
    which contains information about the example that the wrapper will run.
    The closure must call runExample() exactly once.
*/
public typealias AroundExampleWithMetadataAsyncClosure =
    @Sendable (_ exampleMetadata: ExampleMetadata, _ runExample: @Sendable @escaping () async -> Void) async -> Void

/**
    A closure which wraps an example. The closure is given example metadata,
    which contains information about the example that the wrapper will run.
    The closure must call runExample() exactly once.
 
    Synchronous version for legacy and Objc support.
*/
public typealias AroundExampleWithMetadataClosure =
@Sendable (_ exampleMetadata: ExampleMetadata, _ runExample: @Sendable @escaping () -> Void) -> Void

// MARK: Suite Hooks

/**
    A closure executed before any examples are run.
*/
public typealias BeforeSuiteAsyncClosure = @Sendable () async -> Void

/**
    A closure executed before any examples are run.
    Synchronous version for Objc support.
*/
public typealias BeforeSuiteClosure = @Sendable () -> Void

/**
    A closure executed after all examples have finished running.
*/
public typealias AfterSuiteAsyncClosure = BeforeSuiteAsyncClosure

/**
    A closure executed after all examples have finished running.
    Synchronous version for Objc support.
*/
public typealias AfterSuiteClosure = BeforeSuiteClosure
