import Foundation

/**
    A closure that, when evaluated, returns a dictionary of key-value
    pairs that can be accessed from within a group of shared examples.
*/
public typealias SharedExampleContext = () -> (NSDictionary)

/**
    A closure that is used to define a group of shared examples. This
    closure may contain any number of example and example groups.
*/
public typealias SharedExampleClosure = (SharedExampleContext) -> ()

/**
    A mapping of string keys to booleans that can be used to
    filter examples or example groups. For example, a "focused"
    example would have the flags ["focused": true].

    TODO: Define constants for "focused" and "pending".
*/
public typealias FilterFlags = [String: Bool]

/**
    A collection of state Quick builds up in order to work its magic.
    World is primarily responsible for maintaining a mapping of QuickSpec
    classes to root example groups for those classes.

    It also maintains a mapping of shared example names to shared
    example closures.

    You may configure how Quick behaves by calling the -[World configure:]
    method from within an overridden +[QuickConfiguration configure:] method.
*/
@objc final public class World {
    /**
        The example group that is currently being run.
        The DSL requires that this group is correctly set in order to build a
        correct hierarchy of example groups and their examples.
    */
    public var currentExampleGroup: ExampleGroup?

    /**
        The example metadata of the test that is currently being run.
        This is useful for using the Quick test metadata (like its name) at
        runtime.
    */

    public var currentExampleMetadata: ExampleMetadata?

    /**
        A flag that indicates whether additional test suites are being run
        within this test suite. This is only true within the context of Quick
        functional tests.
    */
    public var isRunningAdditionalSuites = false

    private var specs: Dictionary<String, ExampleGroup> = [:]
    private var sharedExamples: [String: SharedExampleClosure] = [:]
    private let configuration = Configuration()
    private var isConfigurationFinalized = false

    internal var exampleHooks: ExampleHooks {return configuration.exampleHooks }
    internal var suiteHooks: SuiteHooks { return configuration.suiteHooks }
    public var runAllWhenEverythingFiltered: Bool { return configuration.runAllWhenEverythingFiltered }

    // MARK: Singleton Constructor

    private init() {}
    private struct Shared {
        static let instance = World()
    }
    public class func sharedWorld() -> World {
        return Shared.instance
    }

    // MARK: Public Interface

    /**
        Exposes the World's Configuration object within the scope of the closure
        so that it may be configured. This method must not be called outside of
        an overridden +[QuickConfiguration configure:] method.

        :param: closure  A closure that takes a Configuration object that can
                         be mutated to change Quick's behavior.
    */
    public func configure(closure: QuickConfigurer) {
        assert(!isConfigurationFinalized,
               "Quick cannot be configured outside of a +[QuickConfiguration configure:] method. You should not call -[World configure:] directly. Instead, subclass QuickConfiguration and override the +[QuickConfiguration configure:] method.")
        closure(configuration: configuration)
    }

    /**
        Finalizes the World's configuration.
        Any subsequent calls to World.configure() will raise.
    */
    public func finalizeConfiguration() {
        isConfigurationFinalized = true
    }


    /**
        Returns an internally constructed root example group for the given
        QuickSpec class.

        A root example group with the description "root example group" is lazily
        initialized for each QuickSpec class. This root example group wraps the
        top level of a -[QuickSpec spec] method--it's thanks to this group that
        users can define beforeEach and it closures at the top level, like so:

            override func spec() {
                // These belong to the root example group
                beforeEach {}
                it("is at the top level") {}
            }

        :param: cls The QuickSpec class for which to retrieve the root example group.
        :returns: The root example group for the class.
    */
    public func rootExampleGroupForSpecClass(cls: AnyClass) -> ExampleGroup {
        let name = NSStringFromClass(cls)
        if let group = specs[name] {
            return group
        } else {
            let group = ExampleGroup(description: "root example group",
                                     isInternalRootExampleGroup: true)
            specs[name] = group
            return group
        }
    }

    /**
        Passes the example through Quick.Configuration's registered filters,
        in order to determine whether the example should be run or not.

        :param: example An example that Quick.Configuration will determine whether to run or not.
        :return: A boolean indicating whether the given example should run. True if the example
                 is included in an inclusion filter, and also **not included** in an exclusion filter.
    */
    public func shouldRun(example: Example) -> Bool {
        var run = true
        run = reduce(configuration.inclusionFilters.map({ $0(example: example) }), run, { run, next in run && next })
        run = reduce(configuration.exclusionFilters.map({ $0(example: example) }), run, { run, next in run && !next })
        return run
    }


    // MARK: Internal

    internal var exampleCount: Int {
        var count = 0
        for (_, group) in specs {
            group.walkDownExamples { _ in count += 1 }
        }
        return count
    }

    internal func registerSharedExample(name: String, closure: SharedExampleClosure) {
        raiseIfSharedExampleAlreadyRegistered(name)
        sharedExamples[name] = closure
    }

    internal func sharedExample(name: String) -> SharedExampleClosure {
        raiseIfSharedExampleNotRegistered(name)
        return sharedExamples[name]!
    }

    private func raiseIfSharedExampleAlreadyRegistered(name: String) {
        if sharedExamples[name] != nil {
            NSException(name: NSInternalInconsistencyException,
                reason: "A shared example named '\(name)' has already been registered.",
                userInfo: nil).raise()
        }
    }

    private func raiseIfSharedExampleNotRegistered(name: String) {
        if sharedExamples[name] == nil {
            NSException(name: NSInternalInconsistencyException,
                reason: "No shared example named '\(name)' has been registered. Registered shared examples: '\(Array(sharedExamples.keys))'",
                userInfo: nil).raise()
        }
    }
}
