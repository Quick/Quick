//
//  Example.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

class Example {
    var group: ExampleGroup?
    var description: String
    var closure: () -> ()
    var name: String { get { return group!.name + ", " + description } }

    init(_ description: String, _ closure: () -> ()) {
        self.description = description
        self.closure = closure
    }

    func run() {
        for before in group!.befores {
            before()
        }

        closure()

        for after in group!.afters {
            after()
        }
    }
}
