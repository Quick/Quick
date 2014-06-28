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
        World.sharedWorld().appendBeforeSuite(closure)
    }

    class func afterSuite(closure: () -> ()) {
        World.sharedWorld().appendAfterSuite(closure)
    }

    class func sharedExamples(name: String, closure: SharedExampleClosure) {
        World.sharedWorld().registerSharedExample(name, closure: closure)
    }

    class func describe(description: String, closure: () -> ()) {
        var group = ExampleGroup(description)
        World.sharedWorld().currentExampleGroup!.appendExampleGroup(group)
        World.sharedWorld().currentExampleGroup = group
        closure()
        World.sharedWorld().currentExampleGroup = group.parent
    }

    class func context(description: String, closure: () -> ()) {
        self.describe(description, closure: closure)
    }

    class func beforeEach(closure: () -> ()) {
        World.sharedWorld().currentExampleGroup!.appendBefore(closure)
    }

    class func afterEach(closure: () -> ()) {
        World.sharedWorld().currentExampleGroup!.appendAfter(closure)
    }

    class func it(description: String, file: String, line: Int, closure: () -> ()) {
        let callsite = Callsite(file: file, line: line)
        let example = Example(description, callsite, closure)
        World.sharedWorld().currentExampleGroup!.appendExample(example)
    }

    class func itBehavesLike(name: String, sharedExampleContext: SharedExampleContext, file: String, line: Int) {
        let callsite = Callsite(file: file, line: line)
        let closure = World.sharedWorld().sharedExample(name)

        var group = ExampleGroup(name)
        World.sharedWorld().currentExampleGroup!.appendExampleGroup(group)
        World.sharedWorld().currentExampleGroup = group
        closure(sharedExampleContext)
        World.sharedWorld().currentExampleGroup!.walkDownExamples { (example: Example) in
            example.isSharedExample = true
            example.callsite = callsite
        }

        World.sharedWorld().currentExampleGroup = group.parent
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

func sharedExamples(name: String, closure: () -> ()) {
    DSL.sharedExamples(name, closure: { (NSDictionary) in closure() })
}

func sharedExamples(name: String, closure: SharedExampleClosure) {
    DSL.sharedExamples(name, closure: closure)
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

func itBehavesLike(name: String, file: String = __FILE__, line: Int = __LINE__) {
    itBehavesLike(name, { return [:] }, file: file, line: line)
}

func itBehavesLike(name: String, sharedExampleContext: SharedExampleContext, file: String = __FILE__, line: Int = __LINE__) {
    DSL.itBehavesLike(name, sharedExampleContext: sharedExampleContext, file: file, line: line)
}

func pending(description: String, closure: () -> ()) {
    DSL.pending(description, closure: closure)
}
