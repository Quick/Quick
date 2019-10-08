import Foundation

/**
    Example groups are logical groupings of examples, defined with
    the `describe` and `context` functions. Example groups can share
    setup and teardown code.
*/
final public class ExampleGroup: NSObject {
    weak internal var parent: ExampleGroup?
    internal let hooks = ExampleHooks()

    internal var phase: HooksPhase = .nothingExecuted

    private let internalDescription: String
    private let flags: FilterFlags
    private let order: Order
    private let isInternalRootExampleGroup: Bool
    private var childGroups = [ExampleGroup]()
    private var childExamples = [Example]()
    private var groupUnits = [Any]()

    internal init(description: String, order: Order, flags: FilterFlags, isInternalRootExampleGroup: Bool = false) {
        self.internalDescription = description
        self.order = order
        self.flags = flags
        self.isInternalRootExampleGroup = isInternalRootExampleGroup
    }

    public override var description: String {
        return internalDescription
    }

    /**
     Returns an ordered list of examples that belong to this example group,
     or to any of its descendant example groups.

     The ordering of these examples is determined by the value of `order`
     passed into the `ExampleGroup`'s constructor. (defaults to Order.defined)
     */
    #if canImport(Darwin)
    @objc
    public var examples: [Example] {
        switch order {
        case .defined:
            return examplesAsDefined
        case .random:
            return randomizedExamples
        }
    }
    #else
    public var examples: [Example] {
        switch order {
        case .defined:
            return examplesAsDefined
        case .random:
            return randomizedExamples
        }
    }
    #endif

    private var examplesAsDefined: [Example] {
        var result = [Example]()
        groupUnits.forEach { unit in
            if let example = unit as? Example {
                result.append(example)
            } else if let exampleGroup = unit as? ExampleGroup {
                result.append(contentsOf: exampleGroup.examples)
            }
        }

        return result
    }

    private var randomizedExamples: [Example] {
        var randomized = Array(groupUnits)
        for (firstUnshuffled, unshuffledCount) in zip(randomized.indices, stride(from: randomized.count, to: 1, by: -1)) {
            #if os(Linux)
                srandom(UInt32(time(nil)))
                let offset: Int = Int(random() % (unshuffledCount + 1))
            #else
                let offset: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            #endif
            let item = randomized.index(firstUnshuffled, offsetBy: offset)

            #if swift(>=4.0)
                randomized.swapAt(firstUnshuffled, item)
            #else
                swap(&randomized[firstUnshuffled], &randomized[i])
            #endif
        }

        var result = [Example]()
        randomized.forEach { unit in
            if let example = unit as? Example {
                result.append(example)
            } else if let exampleGroup = unit as? ExampleGroup {
                result.append(contentsOf: exampleGroup.examples)
            }
        }

        return result
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

    internal var befores: [BeforeExampleWithMetadataClosure] {
        var closures = Array(hooks.befores.reversed())
        walkUp { group in
            closures.append(contentsOf: Array(group.hooks.befores.reversed()))
        }
        return Array(closures.reversed())
    }

    internal var afters: [AfterExampleWithMetadataClosure] {
        var closures = hooks.afters
        walkUp { group in
            closures.append(contentsOf: group.hooks.afters)
        }
        return closures
    }

    internal func walkDownExamples(_ callback: (_ example: Example) -> Void) {
        for example in childExamples {
            callback(example)
        }
        for group in childGroups {
            group.walkDownExamples(callback)
        }
    }

    internal func appendExampleGroup(_ group: ExampleGroup) {
        group.parent = self
        childGroups.append(group)
        groupUnits.append(group)
    }

    internal func appendExample(_ example: Example) {
        example.group = self
        childExamples.append(example)
        groupUnits.append(example)
    }

    private func walkUp(_ callback: (_ group: ExampleGroup) -> Void) {
        var group = self
        while let parent = group.parent {
            callback(parent)
            group = parent
        }
    }
}
