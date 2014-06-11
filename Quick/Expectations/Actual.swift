//
//  Actual.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

class Actual<T> {
    let actual: () -> T
    let callsite: Callsite

    init(_ actual: () -> T, callsite: Callsite) {
        self.actual = actual
        self.callsite = callsite
    }

    var to: Expectation<T> {
        get { return Expectation(actual, callsite: callsite, negative: false) }
    }
    var notTo: Expectation<T> {
        get { return Expectation(actual, callsite: callsite, negative: true) }
    }
    var toNot: Expectation<T> { get { return notTo } }
}
