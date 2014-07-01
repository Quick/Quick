//
//  ClosureExpectation.swift
//  Nimble
//
//  Created by Brian Ivan Gesiak on 6/9/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation


class ClosureExpectation: Prediction {
    let actualClosure: () -> (NSObject?)

    init(_ actualClosure: () -> NSObject?, callsite: Callsite, negative: Bool) {
        self.actualClosure = actualClosure
        super.init(callsite: callsite, negative: negative)
    }

    override func evaluate(matcher: Matcher) {
        let actual = actualClosure()
        let matched = matcher.match(actual)
        if negative && matched {
            fail(matcher.negativeFailureMessage(actual), callsite: callsite)
        } else if !negative && !matched {
            fail(matcher.failureMessage(actual), callsite: callsite)
        }
    }

    func evaluateClosure(matcher: Matcher) {
        let matched = matcher.matchClosure(actualClosure)
        if negative && matched {
            fail(matcher.negativeFailureMessageForClosure(actualClosure), callsite: callsite)
        } else if !negative && !matched {
            fail(matcher.failureMessageForClosure(actualClosure), callsite: callsite)
        }
    }
}
