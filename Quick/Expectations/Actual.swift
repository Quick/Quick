//
//  Actual.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

class Actual {
    let actual: NSObject
    let callsite: Callsite

    init(_ actual: NSObject, callsite: Callsite) {
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

class ActualClosure {
    let actualClosure: () -> (NSObject)
    let callsite: Callsite

    init(_ actualClosure: () -> (NSObject), callsite: Callsite) {
        self.actualClosure = actualClosure
        self.callsite = callsite
    }

    var will: AsynchronousExpectation {
        get {
            return AsynchronousExpectation(actualClosure, callsite: callsite, negative: false)
        }
    }
    var willNot: AsynchronousExpectation {
        get {
            return AsynchronousExpectation(actualClosure, callsite: callsite, negative: true)
        }
    }
}
