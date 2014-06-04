//
//  ExampleGroup.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

class ExampleGroup {
	var description: String
	var parent: ExampleGroup?
	var localBefores: (() -> ())[] = []
	var localAfters: (() -> ())[] = []
	var groups: ExampleGroup[] = []
	var localExamples: Example[] = []

	init(_ description: String) {
		self.description = description
	}

	var befores: (() -> ())[] {
	get {
		var closures = localBefores
		walkUp() { (group: ExampleGroup) -> () in
			closures.extend(group.localBefores)
		}
		return closures.reverse()
	}
	}

	var afters: (() -> ())[] {
	get {
		var closures = localAfters
		walkUp() { (group: ExampleGroup) -> () in
			closures.extend(group.localAfters)
		}
		return closures
	}
	}

	var examples: Example[] {
	get {
		var examples = localExamples
		for group in groups {
			examples.extend(group.examples)
		}
		return examples
	}
	}

	func run() {
		for example in localExamples {
			example.run()
		}

		for group in groups {
			group.run()
		}
	}

	func walkUp(callback: (group: ExampleGroup) -> ()) {
		var group = self
		while let parent = group.parent {
			callback(group: parent)
			group = parent
		}
	}

	func appendExampleGroup(group: ExampleGroup) {
		group.parent = self
		groups.append(group)
	}

	func appendExample(example: Example) {
		example.group = self
		localExamples.append(example)
	}
}
