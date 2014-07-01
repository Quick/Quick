//
//  Actual.swift
//  Nimble
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

@objc class Actual {
    let actual: NSObject?
    let callsite: Callsite

    init(_ actual: NSObject?, callsite: Callsite) {
        self.actual = actual
        self.callsite = callsite
    }

    var to: Expectation { return Expectation(actual, callsite: callsite, negative: false) }
    var notTo: Expectation { return Expectation(actual, callsite: callsite, negative: true) }
    var toNot: Expectation { return notTo }
}
