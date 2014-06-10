//
//  ActualClosure.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/9/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

class ActualClosure {
    let actualClosure: () -> (Any?)
    let callsite: Callsite

    init(_ actualClosure: () -> (Any?), callsite: Callsite) {
        self.actualClosure = actualClosure
        self.callsite = callsite
    }

    var will: AsyncExpectation {
        get {
            return AsyncExpectation(actualClosure, callsite: callsite, negative: false)
        }
    }
    var willNot: AsyncExpectation {
        get {
            return AsyncExpectation(actualClosure, callsite: callsite, negative: true)
        }
    }

    func willBefore(seconds: NSTimeInterval) -> AsyncExpectation {
        let expectation = will
        expectation.timeOut = seconds
        return expectation
    }

    func willNotBefore(seconds: NSTimeInterval) -> AsyncExpectation {
        let expectation = willNot
        expectation.timeOut = seconds
        return expectation
    }
}