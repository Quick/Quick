// swiftlint:disable line_length

/// A protocol for defining the synchronous DSL usable from Quick synchronous specs.
public protocol SyncDSLUser {}

extension QuickSpec: SyncDSLUser {}
extension Behavior: SyncDSLUser {}
extension QuickConfiguration: SyncDSLUser {}

extension SyncDSLUser {

    // MARK: - beforeSuite
    /**
     Defines a closure to be run prior to any examples in the test suite.
     You may define an unlimited number of these closures, but there is no
     guarantee as to the order in which they're run.

     If the test suite crashes before the first example is run, this closure
     will not be executed.

     - parameter closure: The closure to be run prior to any examples in the test suite.
     */
    public static func beforeSuite(_ closure: @escaping BeforeSuiteClosure) {
        World.sharedWorld.beforeSuite(closure)
    }

    // MARK: - afterSuite
    /**
     Defines a closure to be run after all of the examples in the test suite.
     You may define an unlimited number of these closures, but there is no
     guarantee as to the order in which they're run.

     If the test suite crashes before all examples are run, this closure
     will not be executed.

     - parameter closure: The closure to be run after all of the examples in the test suite.
     */
    public static func afterSuite(_ closure: @escaping AfterSuiteClosure) {
        World.sharedWorld.afterSuite(closure)
    }

    // MARK: - sharedExamples
    /**
     Defines a group of shared examples. These examples can be re-used in several locations
     by using the `itBehavesLike` function.

     - parameter name: The name of the shared example group. This must be unique across all shared example
     groups defined in a test suite.
     - parameter closure: A closure containing the examples. This behaves just like an example group defined
     using `describe` or `context`--the closure may contain any number of `beforeEach`
     and `afterEach` closures, as well as any number of examples (defined using `it`).
     */
    public static func sharedExamples(_ name: String, closure: @escaping () -> Void) {
        World.sharedWorld.sharedExamples(name) { _ in closure() }
    }

    /**
     Defines a group of shared examples. These examples can be re-used in several locations
     by using the `itBehavesLike` function.

     - parameter name: The name of the shared example group. This must be unique across all shared example
     groups defined in a test suite.
     - parameter closure: A closure containing the examples. This behaves just like an example group defined
     using `describe` or `context`--the closure may contain any number of `beforeEach`
     and `afterEach` closures, as well as any number of examples (defined using `it`).

     The closure takes a SharedExampleContext as an argument. This context is a function
     that can be executed to retrieve parameters passed in via an `itBehavesLike` function.
     */
    public static func sharedExamples(_ name: String, closure: @escaping SharedExampleClosure) {
        World.sharedWorld.sharedExamples(name, closure: closure)
    }

    // MARK: - Example groups
    /**
     Defines an example group. Example groups are logical groupings of examples.
     Example groups can share setup and teardown code.

     - parameter description: An arbitrary string describing the example group.
     - parameter closure: A closure that can contain other examples.
     */
    public static func describe(_ description: String, closure: () -> Void) {
        World.sharedWorld.describe(description, closure: closure)
    }

    /**
     Defines an example group. Equivalent to `describe`.
     */
    public static func context(_ description: String, closure: () -> Void) {
        World.sharedWorld.context(description, closure: closure)
    }

    // MARK: - beforeEach
    /**
     Defines a closure to be run prior to each example in the current example
     group. This closure is not run for pending or otherwise disabled examples.
     An example group may contain an unlimited number of beforeEach. They'll be
     run in the order they're defined, but you shouldn't rely on that behavior.

     - parameter closure: The closure to be run prior to each example.
     */
    public static func beforeEach(_ closure: @escaping BeforeExampleClosure) {
        World.sharedWorld.beforeEach(closure)
    }

    /**
     Identical to Quick.DSL.beforeEach, except the closure is provided with
     metadata on the example that the closure is being run prior to.
     */
    public static func beforeEach(_ closure: @escaping BeforeExampleWithMetadataClosure) {
        World.sharedWorld.beforeEach(closure: closure)
    }

    // MARK: - AfterEach
    /**
     Defines a closure to be run after each example in the current example
     group. This closure is not run for pending or otherwise disabled examples.
     An example group may contain an unlimited number of afterEach. They'll be
     run in the order they're defined, but you shouldn't rely on that behavior.

     - parameter closure: The closure to be run after each example.
     */
    public static func afterEach(_ closure: @escaping AfterExampleClosure) {
        World.sharedWorld.afterEach(closure)
    }

    /**
     Identical to Quick.DSL.afterEach, except the closure is provided with
     metadata on the example that the closure is being run after.
     */
    public static func afterEach(_ closure: @escaping AfterExampleWithMetadataClosure) {
        World.sharedWorld.afterEach(closure: closure)
    }

    // MARK: - aroundEach
    /**
     Defines a closure to that wraps each example in the current example
     group. This closure is not run for pending or otherwise disabled examples.

     The closure you pass to aroundEach receives a callback as its argument, which
     it MUST call exactly one for the example to run properly:

     aroundEach { runExample in
     doSomeSetup()
     runExample()
     doSomeCleanup()
     }

     This callback is particularly useful for test decartions that can’t split
     into a separate beforeEach and afterEach. For example, running each example
     in its own autorelease pool (provided by Task) requires aroundEach:

     aroundEach { runExample in
     autoreleasepool {
     runExample()
     }
     checkObjectsNoLongerRetained()
     }

     You can also use aroundEach to guarantee proper nesting of setup and cleanup
     operations in situations where their relative order matters.

     An example group may contain an unlimited number of aroundEach callbacks.
     They will nest inside each other, with the first declared in the group
     nested at the outermost level.

     - parameter closure: The closure that wraps around each example.
     */
    public static func aroundEach(_ closure: @escaping AroundExampleClosure) {
        World.sharedWorld.aroundEach(closure)
    }

    /**
     Identical to Quick.DSL.aroundEach, except the closure receives metadata
     about the example that the closure wraps.
     */
    public static func aroundEach(_ closure: @escaping AroundExampleWithMetadataClosure) {
        World.sharedWorld.aroundEach(closure)
    }

    // MARK: - Examples
    /**
     Defines a closure to be run prior to each example but after any beforeEach blocks.
     This closure is not run for pending or otherwise disabled examples.
     An example group may contain an unlimited number of justBeforeEach. They'll be
     run in the order they're defined, but you shouldn't rely on that behavior.

     - parameter closure: The closure to be run prior to each example and after any beforeEach blocks
     */

    public static func justBeforeEach(_ closure: @escaping BeforeExampleClosure) {
        World.sharedWorld.justBeforeEach(closure)
    }

    /**
     Defines an example. Examples use assertions to demonstrate how code should
     behave. These are like "tests" in XCTest.

     - parameter description: An arbitrary string describing what the example is meant to specify.
     - parameter closure: A closure that can contain assertions.
     - parameter file: The absolute path to the file containing the example. A sensible default is provided.
     - parameter line: The line containing the example. A sensible default is provided.
     */
    public static func it(_ description: String, file: FileString = #file, line: UInt = #line, closure: @escaping () throws -> Void) {
        World.sharedWorld.it(description, file: file, line: line, closure: closure)
    }

    // MARK: - Shared Examples
    /**
     Inserts the examples defined using a `sharedExamples` function into the current example group.
     The shared examples are executed at this location, as if they were written out manually.

     - parameter name: The name of the shared examples group to be executed. This must be identical to the
     name of a shared examples group defined using `sharedExamples`. If there are no shared
     examples that match the name given, an exception is thrown and the test suite will crash.
     - parameter file: The absolute path to the file containing the current example group. A sensible default is provided.
     - parameter line: The line containing the current example group. A sensible default is provided.
     */
    public static func itBehavesLike(_ name: String, file: FileString = #file, line: UInt = #line) {
        itBehavesLike(name, file: file, line: line, sharedExampleContext: { return [:] })
    }

    /**
     Inserts the examples defined using a `sharedExamples` function into the current example group.
     The shared examples are executed at this location, as if they were written out manually.
     This function also passes those shared examples a context that can be evaluated to give the shared
     examples extra information on the subject of the example.

     - parameter name: The name of the shared examples group to be executed. This must be identical to the
     name of a shared examples group defined using `sharedExamples`. If there are no shared
     examples that match the name given, an exception is thrown and the test suite will crash.
     - parameter sharedExampleContext: A closure that, when evaluated, returns key-value pairs that provide the
     shared examples with extra information on the subject of the example.
     - parameter file: The absolute path to the file containing the current example group. A sensible default is provided.
     - parameter line: The line containing the current example group. A sensible default is provided.
     */
    public static func itBehavesLike(_ name: String, file: FileString = #file, line: UInt = #line, sharedExampleContext: @escaping SharedExampleContext) {
        World.sharedWorld.itBehavesLike(name, sharedExampleContext: sharedExampleContext, file: file, line: line)
    }

    /**
     Inserts the examples defined using a `Behavior` into the current example group.
     The shared examples are executed at this location, as if they were written out manually.
     This function also passes a strongly-typed context that can be evaluated to give the shared examples extra information on the subject of the example.

     - parameter behavior: The type of `Behavior` class defining the example group to be executed.
     - parameter context: A closure that, when evaluated, returns an instance of `Behavior`'s context type to provide its example group with extra information on the subject of the example.
     - parameter file: The absolute path to the file containing the current example group. A sensible default is provided.
     - parameter line: The line containing the current example group. A sensible default is provided.
     */
    public static func itBehavesLike<C>(_ behavior: Behavior<C>.Type, file: FileString = #file, line: UInt = #line, context: @escaping () -> C) {
        World.sharedWorld.itBehavesLike(behavior, context: context, file: file, line: line)
    }

    // MARK: - Pending
    /**
     Defines an example or example group that should not be executed. Use `pending` to temporarily disable
     examples or groups that should not be run yet.

     - parameter description: An arbitrary string describing the example or example group.
     - parameter closure: A closure that will not be evaluated.
     */
    public static func pending(_ description: String, closure: () throws -> Void) {
        World.sharedWorld.pending(description, closure: closure)
    }

    // MARK: - Defocused
    /**
     Use this to quickly mark a `describe` closure as pending.
     This disables all examples within the closure.
     */
    public static func xdescribe(_ description: String, closure: () -> Void) {
        World.sharedWorld.xdescribe(description, closure: closure)
    }

    /**
     Use this to quickly mark a `context` closure as pending.
     This disables all examples within the closure.
     */
    public static func xcontext(_ description: String, closure: () -> Void) {
        xdescribe(description, closure: closure)
    }

    /**
     Use this to quickly mark an `it` closure as pending.
     This disables the example and ensures the code within the closure is never run.
     */
    public static func xit(_ description: String, file: FileString = #file, line: UInt = #line, closure: @escaping () throws -> Void) {
        World.sharedWorld.xit(description, file: file, line: line, closure: closure)
    }

    /**
     Use this to quickly mark an `itBehavesLike` closure as pending.
     This disables the example group defined by this behavior and ensures the code within is never run.
     */
    public static func xitBehavesLike<C>(_ behavior: Behavior<C>.Type, file: FileString = #file, line: UInt = #line, context: @escaping () -> C) {
        World.sharedWorld.xitBehavesLike(behavior, context: context, file: file, line: line)
    }

    /**
     Use this to quickly mark an `itBehavesLike` closure as pending.
     This disables the example group defined by this behavior and ensures the code within is never run.
     */
    public static func xitBehavesLike(_ name: String, file: FileString = #file, line: UInt = #line) {
        xitBehavesLike(name, file: file, line: line, sharedExampleContext: { return [:] })
    }

    /**
     Use this to quickly mark an `itBehavesLike` closure as pending.
     This disables the example group defined by this behavior and ensures the code within is never run.
     */
    public static func xitBehavesLike(_ name: String, file: FileString = #file, line: UInt = #line, sharedExampleContext: @escaping SharedExampleContext) {
        World.sharedWorld.xitBehavesLike(name, sharedExampleContext: sharedExampleContext, file: file, line: line)
    }

    // MARK: - Focused
    /**
     Use this to quickly focus a `describe` closure, focusing the examples in the closure.
     If any examples in the test suite are focused, only those examples are executed.
     This trumps any explicitly focused or unfocused examples within the closure--they are all treated as focused.
     */
    public static func fdescribe(_ description: String, closure: () -> Void) {
        World.sharedWorld.fdescribe(description, closure: closure)
    }

    /**
     Use this to quickly focus a `context` closure. Equivalent to `fdescribe`.
     */
    public static func fcontext(_ description: String, closure: () -> Void) {
        fdescribe(description, closure: closure)
    }

    /**
     Use this to quickly focus an `it` closure, focusing the example.
     If any examples in the test suite are focused, only those examples are executed.
     */
    public static func fit(_ description: String, file: FileString = #file, line: UInt = #line, closure: @escaping () throws -> Void) {
        World.sharedWorld.fit(description, file: file, line: line, closure: closure)
    }

    /**
     Use this to quickly focus an `itBehavesLike` closure.
     */
    public static func fitBehavesLike(_ name: String, file: FileString = #file, line: UInt = #line) {
        fitBehavesLike(name, file: file, line: line, sharedExampleContext: { return [:] })
    }

    /**
     Use this to quickly focus an `itBehavesLike` closure.
     */
    public static func fitBehavesLike(_ name: String, file: FileString = #file, line: UInt = #line, sharedExampleContext: @escaping SharedExampleContext) {
        World.sharedWorld.fitBehavesLike(name, sharedExampleContext: sharedExampleContext, file: file, line: line)
    }

    /**
     Use this to quickly focus on `itBehavesLike` closure.
     */
    public static func fitBehavesLike<C>(_ behavior: Behavior<C>.Type, file: FileString = #file, line: UInt = #line, context: @escaping () -> C) {
        World.sharedWorld.fitBehavesLike(behavior, context: context, file: file, line: line)
    }
}

// swiftlint:enable line_length
