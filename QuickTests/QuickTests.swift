//
//  QuickTests.swift
//  QuickTests
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import XCTest

// Classes

class Example {
	var group: ExampleGroup?
	var description: String
	var closure: () -> ()

	init(_ description: String, _ closure: () -> ()) {
		self.description = description
		self.closure = closure
	}

	func run() {
		println("Running '\(description)'...")

		if let group = self.group {
			for before in group.befores {
				before()
			}
		}

		closure()
	}
}

class ExampleGroup {
	var description: String
	var parent: ExampleGroup?
	var beforeClosures: (() -> ())[] = []
	var groups: ExampleGroup[] = []
	var examples: Example[] = []

	init(_ description: String) {
		self.description = description
	}

	var befores: (() -> ())[] {
		get {
			var closures = beforeClosures
			var group = self
			while let parent = group.parent {
				closures.extend(parent.beforeClosures)
				group = parent
			}
			return closures.reverse()
		}
	}

	func appendExampleGroup(group: ExampleGroup) {
		group.parent = self
		groups.append(group)
	}

	func appendExample(example: Example) {
		example.group = self
		examples.append(example)
	}

	func run() {
		for example in examples {
			example.run()
		}

		for group in groups {
			group.run()
		}
	}
}

// DSL

var currentExampleGroup: ExampleGroup?

func describe(description: String, closure: () -> ()) {
	var group = ExampleGroup(description)
	if let current = currentExampleGroup {
		current.appendExampleGroup(group)
	}

	currentExampleGroup = group
	closure()
	currentExampleGroup = group.parent
}

func context(description: String, closure: () -> ()) {
	describe(description, closure)
}

func beforeEach(closure: () -> ()) {
	currentExampleGroup!.beforeClosures.append(closure)
}

func it(description: String, closure: () -> ()) {
	let example = Example(description, closure)
	currentExampleGroup!.appendExample(example)
}

// Functional Tests

class QuickTests: XCTestCase {
	class Person {
		var isHappy = true
		var greeting: String {
			get {
				if isHappy {
					return "Hello!"
				} else {
					return "Oh, hi."
				}
			}
		}
	}

	func testDSL() {
		describe("Person") {
			var person: Person?
			beforeEach() {
				person = Person()
			}

			it("is happy") {
				XCTAssert(person!.isHappy, "expected person to be happy by default")
			}

			describe("greeting") {
				context("when the person is unhappy") {
					beforeEach() { person!.isHappy = false }
					it("is lukewarm") {
						XCTAssertEqualObjects(person!.greeting, "Oh, hi.", "expected a lukewarm greeting")
					}
				}

				context("when the person is happy") {
					beforeEach() { person!.isHappy = true }
					it("is enthusiastic") {
						XCTAssertEqualObjects(person!.greeting, "Hello!", "expected an enthusiastic greeting")
					}
				}
			}
		}
	}

    func testWithoutDSL() {
		var root = ExampleGroup("Person")

		var person: Person?
		root.beforeClosures.append() {
			person = Person()
		}

		var itIsHappy = Example("is happy") {
			XCTAssert(person!.isHappy, "expected person to be happy by default")
		}
		root.appendExample(itIsHappy)

		var whenUnhappy = ExampleGroup("when the person is unhappy")
		whenUnhappy.beforeClosures.append() {
			person!.isHappy = false
		}
		var itGreetsHalfheartedly = Example("greets halfheartedly") {
			XCTAssertEqualObjects(person!.greeting, "Oh, hi.", "expected a halfhearted greeting")
		}
		whenUnhappy.appendExample(itGreetsHalfheartedly)
		root.appendExampleGroup(whenUnhappy)

		var whenHappy = ExampleGroup("when the person is happy")
		var itGreetsEnthusiastically = Example("greets enthusiastically") {
			XCTAssertEqualObjects(person!.greeting, "Hello!", "expected an enthusiastic greeting")
		}
		whenHappy.appendExample(itGreetsEnthusiastically)
		root.appendExampleGroup(whenHappy)

		root.run()
    }
}
