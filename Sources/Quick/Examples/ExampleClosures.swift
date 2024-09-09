/**
    A closure for running an example.
 */
public typealias ExampleClosure = @MainActor () throws -> Void

/**
    A closure for defining an example group.
 */
public typealias ExampleGroupClosure = @MainActor () -> Void

/**
    A closure that, when evaluated, returns a dictionary of key-value
    pairs that can be accessed from within a group of shared examples.
*/
public typealias SharedExampleContext = @MainActor () -> [String: Any]

/**
    A closure that is used to define a group of shared examples. This
    closure may contain any number of example and example groups.
*/
public typealias SharedExampleClosure = @MainActor (@escaping SharedExampleContext) -> Void
