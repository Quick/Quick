//
//  DSL.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

@objc class DSL {
    class func beforeSuite(closure: () -> ()) {
        World.appendBeforeSuite(closure)
    }

    class func afterSuite(closure: () -> ()) {
        World.appendAfterSuite(closure)
    }

    class func describe(description: String, closure: () -> ()) {
        var group = ExampleGroup(description)
        World.currentExampleGroup()!.appendExampleGroup(group)
        World.setCurrentExampleGroup(group)
        closure()
        World.setCurrentExampleGroup(group.parent)
    }

    class func context(description: String, closure: () -> ()) {
        self.describe(description, closure: closure)
    }

    class func beforeEach(closure: () -> ()) {
        World.currentExampleGroup()!.appendBefore(closure)
    }

    class func afterEach(closure: () -> ()) {
        World.currentExampleGroup()!.appendAfter(closure)
    }

    class func it(description: String, file: String, line: Int, closure: () -> ()) {
        let callsite = Callsite(file: file, line: line)
        let example = Example(description, callsite, closure)
        World.currentExampleGroup()!.appendExample(example)
    }

    class func pending(description: String, closure: () -> ()) {
        NSLog("Pending: %@", description)
    }
}

func beforeSuite(closure: () -> ()) {
    DSL.beforeSuite(closure)
}

func afterSuite(closure: () -> ()) {
    DSL.afterSuite(closure)
}

func describe(description: String, closure: () -> ()) {
    DSL.describe(description, closure: closure)
}

func context(description: String, closure: () -> ()) {
    describe(description, closure)
}

func beforeEach(closure: () -> ()) {
    DSL.beforeEach(closure)
}

func afterEach(closure: () -> ()) {
    DSL.afterEach(closure)
}

func it(description: String, closure: () -> (), file: String = __FILE__, line: Int = __LINE__) {
    DSL.it(description, file: file, line: line, closure: closure)
}

func pending(description: String, closure: () -> ()) {
    DSL.pending(description, closure: closure)
}
