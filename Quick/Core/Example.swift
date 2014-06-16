//
//  Example.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import XCTest

var _numberOfExamplesRan = 0

@objc class Example {
    weak var group: ExampleGroup?

    var _description: String
    var _closure: () -> ()

    var callsite: Callsite

    var name: String { get { return group!.name + ", " + _description } }

    init(_ description: String, _ callsite: Callsite, _ closure: () -> ()) {
        self._description = description
        self._closure = closure
        self.callsite = callsite
    }

    func run() {
        if _numberOfExamplesRan == 0 {
            World.runBeforeSpec()
        }

        for before in group!.befores {
            before()
        }

        _closure()

        for after in group!.afters {
            after()
        }

        ++_numberOfExamplesRan
        if _numberOfExamplesRan >= World.exampleCount {
            World.runAfterSpec()
        }
    }
}
