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
    private let isInternalRootExampleGroup: Bool
    private var childGroups = [ExampleGroup]()
    private var childExamples = [Example]()
    private var examplesToUniqueIdentifiers = [Example: String]()

    internal init(description: String,
                  flags: FilterFlags,
                  isInternalRootExampleGroup: Bool = false) {
        self.internalDescription = description
        self.flags = flags
        self.isInternalRootExampleGroup = isInternalRootExampleGroup
    }

    public override var description: String {
        return internalDescription
    }

    /**
        Returns a list of examples that belong to this example group,
        or to any of its descendant example groups.
    */
    public var examples: [Example] {
        return childExamples + childGroups.flatMap { $0.examples }
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
    }

    internal func appendExample(_ example: Example) {
        example.group = self
        childExamples.append(example)
    }

    internal func uniqueIdentifier(forExample example: Example) -> String? {
        return examplesToUniqueIdentifiers[example]
    }

    internal func assignUniqueIdentifiersToExamples() {
        if !isInternalRootExampleGroup && parent != nil {
            parent!.assignUniqueIdentifiersToExamples()
            return
        }

        for group in childGroups {
            group.clearUniqueExampleIdentifiers()
        }

        for group in childGroups {
            group.generateUniqueIdentifiersForExamples()
        }
    }

    private func clearUniqueExampleIdentifiers() {
        examplesToUniqueIdentifiers.removeAll()
    }

    private func generateUniqueIdentifiersForExamples() {
        for example in childExamples {
            let uniqueIdentifier = generateUniqueIdentifier(
                givenIdentifierSuffix: example.description
            )

            examplesToUniqueIdentifiers[example] = uniqueIdentifier
        }
    }

    private func generateUniqueIdentifier(givenIdentifierSuffix suffix: String) -> String {
        if isInternalRootExampleGroup {
            return deduplicateIdentifier(suffix)
        }

        if let parent = parent {
            return parent.generateUniqueIdentifier(
                givenIdentifierSuffix: self.description + " " + suffix
            )
        }

        let unformatted = self.description + " " + suffix
        return deduplicateIdentifier(unformatted)
    }

    private func deduplicateIdentifier(_ identifier: String) -> String {
        var uniqueIdentifier = identifier.c99ExtendedIdentifier
        let baseUniqueIdentifier = uniqueIdentifier
        var identifyingTag = 2
        while allExampleUniqueIdentifiers.contains(uniqueIdentifier) {
            uniqueIdentifier = baseUniqueIdentifier + "_\(identifyingTag)"
            identifyingTag += 1
        }

        return uniqueIdentifier
    }

    private var allExampleUniqueIdentifiers: [String] {
        var allIdentifiers = Array(examplesToUniqueIdentifiers.values)
        for group in childGroups {
            allIdentifiers.append(contentsOf: group.allExampleUniqueIdentifiers)
        }

        return allIdentifiers
    }

    private func walkUp(_ callback: (_ group: ExampleGroup) -> Void) {
        var group = self
        while let parent = group.parent {
            callback(parent)
            group = parent
        }
    }
}
