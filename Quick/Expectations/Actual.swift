//
//  Actual.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

class Actual {
    let actual: Any?
    let callsite: Callsite

    init(_ actual: Any?, callsite: Callsite) {
        self.actual = actual
        self.callsite = callsite
    }

    var to: Expectation {
        get { return Expectation(actual, callsite: callsite, negative: false) }
    }
    var notTo: Expectation {
        get { return Expectation(actual, callsite: callsite, negative: true) }
    }
    var toNot: Expectation { get { return notTo } }
}
