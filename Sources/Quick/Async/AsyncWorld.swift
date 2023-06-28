import Foundation

/**
    A collection of state Quick builds up in order to work its magic.

    AsyncWorld is primarily responsible for maintaining a mapping of AsyncSpec
    classes to root example groups for those classes.

    AsyncWorld is the equivalent of World for AsyncSpec.

    It also maintains a mapping of shared example names to shared
    example closures.

    You may configure how Quick behaves by calling the `AsyncWorld.configure(_:)`
    method from within an overridden `class QuickConfiguration.configure(_:)` method.
*/
final internal class AsyncWorld: _WorldBase {
    /**
        The example group that is currently being run.
        The DSL requires that this group is correctly set in order to build a
        correct hierarchy of example groups and their examples.
    */
    internal var currentExampleGroup: AsyncExampleGroup!

    /**
        The example metadata of the test that is currently being run.
        This is useful for using the Quick test metadata (like its name) at
        runtime.
    */

    internal var currentExampleMetadata: AsyncExampleMetadata?

    internal var numberOfAsyncExamplesRun = 0

    /**
        A flag that indicates whether additional test suites are being run
        within this test suite. This is only true within the context of Quick
        functional tests.
    */
    internal var isRunningAdditionalSuites = false

    private var specs: [String: AsyncExampleGroup] = [:]
    private let configuration = QCKConfiguration()

    internal private(set) var isConfigurationFinalized = false

    internal var exampleHooks: AsyncExampleHooks { return World.sharedWorld.asyncExampleHooks }
    internal var suiteHooks: SuiteHooks { return World.sharedWorld.suiteHooks }

    // MARK: Singleton Constructor

    private override init() {}

    static private(set) var sharedWorld = AsyncWorld()

    internal static func anotherWorld<T>(block: (AsyncWorld) -> T) -> T {
        let previous = sharedWorld
        defer { sharedWorld = previous }
        return World.anotherWorld { _ in
            let newWorld = AsyncWorld()
            sharedWorld = newWorld
            return block(newWorld)
        }
    }

    // MARK: Public Interface

    /**
        Exposes the World's QCKConfiguration object within the scope of the closure
        so that it may be configured. This method must not be called outside of
        an overridden `class QuickConfiguration.configure(_:)` method.

        - parameter closure:  A closure that takes a Configuration object that can
                         be mutated to change Quick's behavior.
    */
    internal func configure(_ closure: QuickConfigurer) {
        assert(
            !isConfigurationFinalized,
            // swiftlint:disable:next line_length
            "Quick cannot be configured outside of a `class QuickConfiguration.configure(_:)` method. You should not call `AsyncWorld.configure(_:)` directly. Instead, subclass QuickConfiguration and override the `class QuickConfiguration.configure(_:)` method."
        )
        closure(configuration)
    }

    /**
        Finalizes the World's configuration.
        Any subsequent calls to World.configure() will raise.
    */
    internal func finalizeConfiguration() {
        isConfigurationFinalized = true
    }

    /**
     Returns `true` if the root example group for the given spec class has been already initialized.

     - parameter specClass: The QuickSpec class for which is checked for the existing root example group.
     - returns: Whether the root example group for the given spec class has been already initialized or not.
     */
    internal func isRootExampleGroupInitialized(forSpecClass specClass: AsyncSpec.Type) -> Bool {
        let name = String(describing: specClass)
        return specs.keys.contains(name)
    }

    /**
        Returns an internally constructed root example group for the given
        AsyncSpec class.

        A root example group with the description "root example group" is lazily
        initialized for each AsyncSpec class. This root example group wraps the
        top level of a `class AsyncSpec.spec()` method--it's thanks to this group that
        users can define beforeEach and it closures at the top level, like so:

            override class func spec() {
                // These belong to the root example group
                beforeEach {}
                it("is at the top level") {}
            }

        - parameter specClass: The AsyncSpec class for which to retrieve the root example group.
        - returns: The root example group for the class.
    */
    internal func rootExampleGroup(forSpecClass specClass: AsyncSpec.Type) -> AsyncExampleGroup {
        let name = String(describing: specClass)

        if let group = specs[name] {
            return group
        } else {
            let group = AsyncExampleGroup(
                description: "root example group",
                flags: [:],
                isInternalRootExampleGroup: true
            )
            specs[name] = group
            return group
        }
    }

    /**
        Returns all examples that should be run for a given spec class.
        There are two filtering passes that occur when determining which examples should be run.
        That is, these examples are the ones that are included by inclusion filters, and are
        not excluded by exclusion filters.

        - parameter specClass: The AsyncSpec subclass for which examples are to be returned.
        - returns: A list of examples to be run as test invocations.
    */
    internal func examples(forSpecClass specClass: AsyncSpec.Type) -> [AsyncExample] {
        // 1. Grab all included examples.
        let included = includedExamples
        // 2. Grab the intersection of (a) examples for this spec, and (b) included examples.
        let spec = rootExampleGroup(forSpecClass: specClass).examples.filter { included.contains($0) }
        // 3. Remove all excluded examples.
        return spec.filter { example in
            !self.configuration.exclusionFilters.contains { $0(example) }
        }
    }

    // MARK: Internal

    internal var includedExampleCount: Int {
        return includedExamples.count
    }

    internal lazy var cachedIncludedExampleCount: Int = self.includedExampleCount

    internal var beforesCurrentlyExecuting: Bool {
        let suiteBeforesExecuting = suiteHooks.phase == .beforesExecuting
        let exampleBeforesExecuting = exampleHooks.phase == .beforesExecuting
        var groupBeforesExecuting = false
        if let runningExampleGroup = currentExampleMetadata?.group {
            groupBeforesExecuting = runningExampleGroup.phase == .beforesExecuting
        }

        return suiteBeforesExecuting || exampleBeforesExecuting || groupBeforesExecuting
    }

    internal var aftersCurrentlyExecuting: Bool {
        let suiteAftersExecuting = suiteHooks.phase == .aftersExecuting
        let exampleAftersExecuting = exampleHooks.phase == .aftersExecuting
        var groupAftersExecuting = false
        if let runningExampleGroup = currentExampleMetadata?.group {
            groupAftersExecuting = runningExampleGroup.phase == .aftersExecuting
        }

        return suiteAftersExecuting || exampleAftersExecuting || groupAftersExecuting
    }

    internal func performWithCurrentExampleGroup(_ group: AsyncExampleGroup, closure: () -> Void) {
        let previousExampleGroup = currentExampleGroup
        currentExampleGroup = group

        closure()

        currentExampleGroup = previousExampleGroup
    }

    private var allExamples: [AsyncExample] {
        var all: [AsyncExample] = []
        for (_, group) in specs {
            group.walkDownExamples { all.append($0) }
        }
        return all
    }

    private var includedExamples: [AsyncExample] {
        let all = allExamples
        let included = all.filter { example in
            return self.configuration.inclusionFilters.contains { $0(example) }
        }

        if included.isEmpty && configuration.runAllWhenEverythingFiltered {
            let exceptExcluded = all.filter { example in
                return !self.configuration.exclusionFilters.contains { $0(example) }
            }

            return exceptExcluded
        } else {
            return included
        }
    }
}
