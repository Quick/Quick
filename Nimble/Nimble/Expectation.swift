//
//  Expectation.swift
//  Nimble
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import XCTest

class Expectation: Prediction {
    let actual: NSObject?

    init(_ actual: NSObject?, callsite: Callsite, negative: Bool) {
        self.actual = actual
        super.init(callsite: callsite, negative: negative)
    }

    override func evaluate(matcher: Matcher) {
        let matched = matcher.match(actual)
        if negative && matched {
            fail(matcher.negativeFailureMessage(actual), callsite: callsite)
        } else if !negative && !matched {
            fail(matcher.failureMessage(actual), callsite: callsite)
        }
    }
}
