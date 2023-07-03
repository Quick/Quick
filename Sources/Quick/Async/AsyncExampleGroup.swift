import Foundation

private enum ExampleUnit {
    case example(AsyncExample)
    case group(AsyncExampleGroup)
}

/**
    Example groups are logical groupings of examples, defined with
    the `describe` and `context` functions. Example groups can share
    setup and teardown code.
*/
final public class AsyncExampleGroup: CustomStringConvertible {
    weak internal var parent: AsyncExampleGroup?
    internal let hooks = AsyncExampleHooks()

    internal var phase: HooksPhase = .nothingExecuted

    private let internalDescription: String
    private let flags: FilterFlags
    private let isInternalRootExampleGroup: Bool
    private var childUnits = [ExampleUnit]()

    internal init(description: String, flags: FilterFlags, isInternalRootExampleGroup: Bool = false) {
        self.internalDescription = description
        self.flags = flags
        self.isInternalRootExampleGroup = isInternalRootExampleGroup
    }

    public var description: String {
        return internalDescription
    }

    /**
        Returns a list of examples that belong to this example group,
        or to any of its descendant example groups.
    */
    public var examples: [AsyncExample] {
        childUnits.flatMap { unit in
            switch unit {
            case .example(let example):
                return [example]
            case .group(let exampleGroup):
                return exampleGroup.examples
            }
        }
    }

    internal var name: String? {
        guard let parent = parent else {
            return isInternalRootExampleGroup ? nil : description
        }

        guard let name = parent.name else { return description }
        return "\(name), \(description)"
    }

    internal var filterFlags: FilterFlags {
        var aggregateFlags = flags
        walkUp { group in
            for (key, value) in group.flags {
                aggregateFlags[key] = value
            }
        }
        return aggregateFlags
    }

    internal var justBeforeEachStatements: [AroundExampleWithMetadataAsyncClosure] {
        var closures = Array(hooks.justBeforeEachStatements.reversed())
        walkUp { group in
            closures.append(contentsOf: group.hooks.justBeforeEachStatements.reversed())
        }
        return closures
    }

    internal var wrappers: [AroundExampleWithMetadataAsyncClosure] {
        var closures = Array(hooks.wrappers.reversed())
        walkUp { group in
            closures.append(contentsOf: group.hooks.wrappers.reversed())
        }
        return closures
    }

    internal func walkDownExamples(_ callback: (_ example: AsyncExample) -> Void) {
        for unit in childUnits {
            switch unit {
            case .example(let example):
                callback(example)
            case .group(let exampleGroup):
                exampleGroup.walkDownExamples(callback)
            }
        }
    }

    internal func appendExampleGroup(_ group: AsyncExampleGroup) {
        group.parent = self
        childUnits.append(.group(group))
    }

    internal func appendExample(_ example: AsyncExample) {
        example.group = self
        childUnits.append(.example(example))
    }

    private func walkUp(_ callback: (_ group: AsyncExampleGroup) -> Void) {
        var group = self
        while let parent = group.parent {
            callback(parent)
            group = parent
        }
    }
}
