//
//  ExampleGroup.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

@objc class ExampleGroup {
    weak var parent: ExampleGroup?

    var _description: String
    var _localBefores: (() -> ())[] = []
    var _localAfters: (() -> ())[] = []
    var _groups: ExampleGroup[] = []
    var _localExamples: Example[] = []

    init(_ description: String) {
        self._description = description
    }

    var befores: (() -> ())[] {
        get {
            var closures = _localBefores
            walkUp() { (group: ExampleGroup) -> () in
                closures.extend(group._localBefores)
            }
            return closures.reverse()
        }
    }

    var afters: (() -> ())[] {
        get {
            var closures = _localAfters
            walkUp() { (group: ExampleGroup) -> () in
                closures.extend(group._localAfters)
            }
            return closures
        }
    }

    var examples: Example[] {
        get {
            var examples = _localExamples
            for group in _groups {
                examples.extend(group.examples)
            }
            return examples
        }
    }

    var name: String {
        get {
            var name = _description
            walkUp() { (group: ExampleGroup) -> () in
                if group.parent {
                    name = group._description + ", " + name
                }
            }
            return name
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

    func appendBefore(closure: () -> ()) {
        _localBefores.append(closure)
    }

    func appendAfter(closure: () -> ()) {
        _localAfters.append(closure)
    }
}
