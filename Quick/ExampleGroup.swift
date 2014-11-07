@objc public class ExampleGroup {
    internal let hooks = ExampleHooks()

    weak var parent: ExampleGroup?

    private let description: String
    private let isInternalRootExampleGroup: Bool
    var _groups = [ExampleGroup]()
    var _localExamples = [Example]()

    init(description: String, isInternalRootExampleGroup: Bool = false) {
        self.description = description
        self.isInternalRootExampleGroup = isInternalRootExampleGroup
    }

    var befores: [BeforeExampleWithMetadataClosure] {
        get {
            var closures = hooks.befores
            walkUp() { (group: ExampleGroup) -> () in
                closures.extend(group.hooks.befores)
            }
            return closures.reverse()
        }
    }

    var afters: [AfterExampleWithMetadataClosure] {
        get {
            var closures = hooks.afters
            walkUp() { (group: ExampleGroup) -> () in
                closures.extend(group.hooks.afters)
            }
            return closures
        }
    }

    public var examples: [Example] {
        get {
            var examples = _localExamples
            for group in _groups {
                examples.extend(group.examples)
            }
            return examples
        }
    }

    var name: String? {
        if let parent = parent {
            switch(parent.name) {
                case .Some(let name): return "\(name), \(description)"
                case .None: return description
            }
        } else {
            return isInternalRootExampleGroup ? nil : description
        }
    }

    func run() {
        walkDownExamples { (example: Example) -> () in
            example.run()
        }
    }

    func walkUp(callback: (group: ExampleGroup) -> ()) {
        var group = self
        while let parent = group.parent {
            callback(group: parent)
            group = parent
        }
    }

    func walkDownExamples(callback: (example: Example) -> ()) {
        for example in _localExamples {
            callback(example: example)
        }
        for group in _groups {
            group.walkDownExamples(callback)
        }
    }

    func appendExampleGroup(group: ExampleGroup) {
        group.parent = self
        _groups.append(group)
    }

    func appendExample(example: Example) {
        example.group = self
        _localExamples.append(example)
    }
}
