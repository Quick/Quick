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
    init(_ actual: NSObject) {
        self.actual = actual
    }
    
    var to: Expectation { get { return Expectation(actual, negative: false) } }
    var notTo: Expectation { get { return Expectation(actual, negative: true) } }
    var toNot: Expectation { get { return notTo } }
}

class ActualClosure {
    let actualClosure: () -> (NSObject)
    init(_ actualClosure: () -> (NSObject)) {
        self.actualClosure = actualClosure
    }

    var will: AsynchronousExpectation {
        get { return AsynchronousExpectation(actualClosure, negative: false) }
    }
    var willNot: AsynchronousExpectation {
        get { return AsynchronousExpectation(actualClosure, negative: true) }
    }
}
