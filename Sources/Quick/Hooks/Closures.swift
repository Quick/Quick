// MARK: Example Hooks

/**
    An async throwing closure executed before an example is run.
*/
public typealias BeforeExampleAsyncClosure = () async throws -> Void

/**
    A throwing closure executed before an example is run.
 */
public typealias BeforeExampleClosure = () throws -> Void

/**
    A closure executed before an example is run.
    This is only used by ObjC.
 */
public typealias BeforeExampleNonThrowingClosure = () -> Void

/**
    An async throwing closure executed before an example is run. The closure is given example metadata,
    which contains information about the example that is about to be run.
*/
public typealias BeforeExampleWithMetadataAsyncClosure = (_ exampleMetadata: ExampleMetadata) async throws -> Void

/**
    A throwing closure executed before an example is run. The closure is given example metadata,
    which contains information about the example that is about to be run.
 */
public typealias BeforeExampleWithMetadataClosure = (_ exampleMetadata: ExampleMetadata) throws -> Void

/**
    A closure executed before an example is run. The closure is given example metadata,
    which contains information about the example that is about to be run.
    This is only used by ObjC
 */
public typealias BeforeExampleWithMetadataNonThrowingClosure = (_ exampleMetadata: ExampleMetadata) -> Void

/**
    An async throwing closure executed after an example is run.
*/
public typealias AfterExampleAsyncClosure = BeforeExampleAsyncClosure

/**
    A throwing closure executed after an example is run.
*/
public typealias AfterExampleClosure = BeforeExampleClosure

/**
    A closure executed after an example is run.
    This is only used by ObjC
*/
public typealias AfterExampleNonThrowingClosure = BeforeExampleNonThrowingClosure

/**
    An async throwing closure executed after an example is run. The closure is given example metadata,
    which contains information about the example that has just finished running.
*/
public typealias AfterExampleWithMetadataAsyncClosure = BeforeExampleWithMetadataAsyncClosure

/**
    A throwing closure executed after an example is run. The closure is given example metadata,
    which contains information about the example that has just finished running.
*/
public typealias AfterExampleWithMetadataClosure = BeforeExampleWithMetadataClosure

/**
    A closure executed after an example is run. The closure is given example metadata,
    which contains information about the example that has just finished running.
*/
public typealias AfterExampleWithMetadataNonThrowingClosure = BeforeExampleWithMetadataNonThrowingClosure

/**
    A throwing closure which wraps an example. The closure must call runExample() exactly once.
*/
public typealias AroundExampleClosure = (_ runExample: @escaping () -> Void) throws -> Void

/**
    A closure which wraps an example. The closure must call runExample() exactly once.
*/
public typealias AroundExampleNonThrowingClosure = (_ runExample: @escaping () -> Void) -> Void

/**
    A throwing closure which wraps an example. The closure is given example metadata,
    which contains information about the example that the wrapper will run.
    The closure must call runExample() exactly once.
*/
public typealias AroundExampleWithMetadataClosure =
    (_ exampleMetadata: ExampleMetadata, _ runExample: @escaping () -> Void) throws -> Void

/**
    A throwing closure which wraps an example. The closure is given example metadata,
    which contains information about the example that the wrapper will run.
    The closure must call runExample() exactly once.
*/
public typealias AroundExampleWithMetadataNonThrowingClosure =
    (_ exampleMetadata: ExampleMetadata, _ runExample: @escaping () -> Void) -> Void

/**
    An async throwing closure which wraps an example. The closure must call runExample() exactly once.
*/
public typealias AroundExampleAsyncClosure = (_ runExample: @escaping () async -> Void) async throws -> Void

/**
    An async throwing closure which wraps an example. The closure is given example metadata,
    which contains information about the example that the wrapper will run.
    The closure must call runExample() exactly once.
*/
public typealias AroundExampleWithMetadataAsyncClosure =
    (_ exampleMetadata: ExampleMetadata, _ runExample: @escaping () async -> Void) async throws -> Void

// MARK: Suite Hooks

/**
    An async throwing closure executed before any examples are run.
*/
public typealias BeforeSuiteAsyncClosure = () async throws -> Void

/**
    A throwing closure executed before any examples are run.
*/
public typealias BeforeSuiteClosure = () throws -> Void

/**
    A closure executed before any examples are run.
*/
public typealias BeforeSuiteNonThrowingClosure = () -> Void

/**
    An async throwing closure executed after all examples have finished running.
*/
public typealias AfterSuiteAsyncClosure = BeforeSuiteAsyncClosure

/**
    A throwing closure executed after all examples have finished running.
*/
public typealias AfterSuiteClosure = BeforeSuiteClosure

/**
    A closure executed after all examples have finished running.
*/
public typealias AfterSuiteNonThrowingClosure = BeforeSuiteNonThrowingClosure
