//
//  DSL.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

func describe(description: String, closure: () -> ()) {
    var group = ExampleGroup(description)
    World.currentExampleGroup()!.appendExampleGroup(group)
    World.setCurrentExampleGroup(group)
    closure()
    World.setCurrentExampleGroup(group.parent)
}

func context(description: String, closure: () -> ()) {
    describe(description, closure)
}

func beforeEach(closure: () -> ()) {
    World.currentExampleGroup()!.appendBefore(closure)
}

func afterEach(closure: () -> ()) {
    World.currentExampleGroup()!.appendAfter(closure)
}

func beforeSuite(closure: () -> ()) {
    // Fill me in
}

func afterSuite(closure: () -> ()) {
    // Fill me in
}

func it(description: String, closure: () -> ()) {
    let example = Example(description, closure)
    World.currentExampleGroup()!.appendExample(example)
}
