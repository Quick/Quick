import Foundation
import XCTest

public final class Example: ExampleBase {
    /**
        A boolean indicating whether the example is a shared example;
        i.e.: whether it is an example defined with `itBehavesLike`.
    */
    public var isSharedExample = false

    weak internal var group: ExampleGroup? {
        didSet {
            resetName()
        }
    }

    private let internalDescription: String
    private let flags: FilterFlags
    private let closure: () throws -> Void

    internal init(description: String, callsite: Callsite, flags: FilterFlags, closure: @escaping () throws -> Void) {
        self.internalDescription = description
        self.flags = flags
        self.closure = closure
        super.init(name: internalDescription, callsite: callsite)

        resetName()
    }

    public override var description: String {
        return internalDescription
    }

    /**
        The example name. A name is a concatenation of the name of
        the example group the example belongs to, followed by the
        description of the example itself.

        The example name is used to generate a test method selector
        to be displayed in Xcode's test navigator.
    */
    private func resetName() {
        name = {
            guard let groupName = group?.name else { return description }
            return "\(groupName), \(description)"
        }()
    }

    public func run() {
        let world = World.sharedWorld

        if world.numberOfExamplesRun == 0 {
            world.suiteHooks.executeBefores()
        }

        let exampleMetadata = ExampleMetadata(example: self, exampleIndex: world.numberOfExamplesRun)
        world.currentExampleMetadata = exampleMetadata
        defer {
            world.currentExampleMetadata = nil
        }

        group!.phase = .beforesExecuting

        let runExample: () -> Void = { [closure] in
            self.group!.phase = .beforesFinished

            do {
                try closure()
            } catch {
                self.handleThrownErrorFromTest(error: error)
            }

            self.group!.phase = .aftersExecuting
        }

        let allJustBeforeEachStatements = group!.justBeforeEachStatements + world.exampleHooks.justBeforeEachStatements
        let justBeforeEachExample = allJustBeforeEachStatements.reduce(runExample) { closure, wrapper in
            return { wrapper(exampleMetadata, closure) }
        }

        let allWrappers = group!.wrappers + world.exampleHooks.wrappers
        let wrappedExample = allWrappers.reduce(justBeforeEachExample) { closure, wrapper in
            return { wrapper(exampleMetadata, closure) }
        }
        wrappedExample()

        group!.phase = .aftersFinished

        world.numberOfExamplesRun += 1

        if !world.isRunningAdditionalSuites && world.numberOfExamplesRun >= world.cachedIncludedExampleCount {
            world.suiteHooks.executeAfters()
        }
    }

    /**
        Evaluates the filter flags set on this example and on the example groups
        this example belongs to. Flags set on the example are trumped by flags on
        the example group it belongs to. Flags on inner example groups are trumped
        by flags on outer example groups.
    */
    internal var filterFlags: FilterFlags {
        var aggregateFlags = flags
        for (key, value) in group!.filterFlags {
            aggregateFlags[key] = value
        }
        return aggregateFlags
    }
}

extension Example {
    /**
        Returns a boolean indicating whether two Example objects are equal.
        If two examples are defined at the exact same callsite, they must be equal.
    */
    @nonobjc public static func == (lhs: Example, rhs: Example) -> Bool {
        return lhs.callsite == rhs.callsite
    }
}
