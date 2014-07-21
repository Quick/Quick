//
//  Example.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import XCTest

var _numberOfExamplesRun = 0

@objc public class Example {
    weak var group: ExampleGroup?

    var _description: String
    var _closure: () -> ()

    public var isSharedExample = false
    public var callsite: Callsite

    public var name: String { get { return group!.name + ", " + _description } }

    init(_ description: String, _ callsite: Callsite, _ closure: () -> ()) {
        self._description = description
        self._closure = closure
        self.callsite = callsite
    }

    public func run() {
        if _numberOfExamplesRun == 0 {
            World.sharedWorld().runBeforeSpec()
        }

        for before in group!.befores {
            before()
        }

        _closure()

        for after in group!.afters {
            after()
        }

        ++_numberOfExamplesRun
        if _numberOfExamplesRun >= World.sharedWorld().exampleCount {
            World.sharedWorld().runAfterSpec()
        }
    }
}
