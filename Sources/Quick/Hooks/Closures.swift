// MARK: Example Hooks

/**
    A closure executed before an example is run.
*/
public typealias BeforeExampleClosure = @Sendable () async -> Void

/**
    A closure executed before an example is run.
    Synchronous version for Objc support.
 */
public typealias BeforeExampleSyncClosure = @Sendable () -> Void

/**
    A closure executed before an example is run. The closure is given example metadata,
    which contains information about the example that is about to be run.
*/
public typealias BeforeExampleWithMetadataClosure = @Sendable (_ exampleMetadata: ExampleMetadata) async -> Void

/**
    A closure executed before an example is run. The closure is given example metadata,
    which contains information about the example that is about to be run.
    Synchronus version for Objc support.
 */
public typealias BeforeExampleWithMetadataSyncClosure = @Sendable (_ exampleMetadata: ExampleMetadata) -> Void

/**
    A closure executed after an example is run.
*/
public typealias AfterExampleClosure = BeforeExampleClosure

/**
    A closure executed after an example is run.
    Synchronous version for Objc support.
*/
public typealias AfterExampleSyncClosure = BeforeExampleSyncClosure

/**
    A closure executed after an example is run. The closure is given example metadata,
    which contains information about the example that has just finished running.
*/
public typealias AfterExampleWithMetadataClosure = BeforeExampleWithMetadataClosure

/**
    A closure executed after an example is run. The closure is given example metadata,
    which contains information about the example that has just finished running.
    Synchronous version for Objc support.
*/
public typealias AfterExampleWithMetadataSyncClosure = BeforeExampleWithMetadataSyncClosure

/**
    A closure which wraps an example. The closure must call runExample() exactly once.
*/
public typealias AroundExampleClosure = @Sendable (_ runExample: @Sendable @escaping () async -> Void) async -> Void

/**
    A closure which wraps an example. The closure must call runExample() exactly once.
    Synchronous version for Objc support.
*/
public typealias AroundExampleSyncClosure = @Sendable (_ runExample: @Sendable @escaping () -> Void) -> Void

/**
    A closure which wraps an example. The closure is given example metadata,
    which contains information about the example that the wrapper will run.
    The closure must call runExample() exactly once.
*/
public typealias AroundExampleWithMetadataClosure =
    @Sendable (_ exampleMetadata: ExampleMetadata, _ runExample: @Sendable @escaping () async -> Void) async -> Void

/**
    A closure which wraps an example. The closure is given example metadata,
    which contains information about the example that the wrapper will run.
    The closure must call runExample() exactly once.
 
    Synchronous version for Objc support.
*/
public typealias AroundExampleWithMetadataSyncClosure =
@Sendable (_ exampleMetadata: ExampleMetadata, _ runExample: @Sendable @escaping () -> Void) -> Void

// MARK: Suite Hooks

/**
    A closure executed before any examples are run.
*/
public typealias BeforeSuiteClosure = @Sendable () async -> Void

/**
    A closure executed before any examples are run.
    Synchronous version for Objc support.
*/
public typealias BeforeSuiteSyncClosure = @Sendable () -> Void

/**
    A closure executed after all examples have finished running.
*/
public typealias AfterSuiteClosure = BeforeSuiteClosure

/**
    A closure executed after all examples have finished running.
    Synchronous version for Objc support.
*/
public typealias AfterSuiteSyncClosure = BeforeSuiteSyncClosure
