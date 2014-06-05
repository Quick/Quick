//
//  Example.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

class Example {
    var group: ExampleGroup?

    var _description: String
    var _closure: () -> ()

    var name: String { get { return group!.name + ", " + _description } }

    init(_ description: String, _ closure: () -> ()) {
        self._description = description
        self._closure = closure
    }

    func run() {
        for before in group!.befores {
            before()
        }

        _closure()

        for after in group!.afters {
            after()
        }
    }
}
