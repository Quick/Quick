//
//  DSL.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import UIKit

var currentExampleGroup = ExampleGroup("root example group")

func describe(description: String, closure: () -> ()) {
	var group = ExampleGroup(description)
	currentExampleGroup.appendExampleGroup(group)

	currentExampleGroup = group
	closure()
	currentExampleGroup = group.parent!
}

func context(description: String, closure: () -> ()) {
	describe(description, closure)
}

func beforeEach(closure: () -> ()) {
	currentExampleGroup.localBefores.append(closure)
}

func afterEach(closure: () -> ()) {
	currentExampleGroup.localAfters.append(closure)
}

func it(description: String, closure: () -> ()) {
	let example = Example(description, closure)
	currentExampleGroup.appendExample(example)
}
