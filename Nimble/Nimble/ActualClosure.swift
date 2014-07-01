//
//  ActualClosure.swift
//  Nimble
//
//  Created by Brian Ivan Gesiak on 6/9/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

@objc class ActualClosure {
    let actualClosure: () -> (NSObject?)
    let callsite: Callsite

    init(_ actualClosure: () -> (NSObject?), callsite: Callsite) {
        self.actualClosure = actualClosure
        self.callsite = callsite
    }

    var to: ClosureExpectation {
        return ClosureExpectation(actualClosure, callsite: callsite, negative: false)
    }
    var notTo: ClosureExpectation {
        return ClosureExpectation(actualClosure, callsite: callsite, negative: true)
    }
    var toNot: ClosureExpectation { return notTo }

    var will: AsyncExpectation {
        return AsyncExpectation(actualClosure, callsite: callsite, negative: false)
    }
    var willNot: AsyncExpectation {
        return AsyncExpectation(actualClosure, callsite: callsite, negative: true)
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