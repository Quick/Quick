//
//  Example.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import XCTest

@objc class Example {
    weak var group: ExampleGroup!

    var _description: String
    var _closure: () -> ()

    var name: String {
        var name = _description
        walkUp { group in
            name = "\(group.name), \(name)"
        }
        return name
    }

    init(_ description: String, _ closure: () -> ()) {
        self._description = description
        self._closure = closure
    }

    func run() {
        for before in group.befores {
            before()
        }

        _closure()

        for after in group.afters {
            after()
        }
    }

    func walkUp(callback: (group: ExampleGroup) -> ()) {
        var group = self.group
        callback(group: group)
        group.walkUp(callback)
    }
}
