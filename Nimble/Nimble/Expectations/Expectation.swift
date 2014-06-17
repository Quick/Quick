//
//  Expectation.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import XCTest
import Quick

class Expectation: Prediction {
    let actual: NSObject?

    init(_ actual: NSObject?, callsite: Callsite, negative: Bool) {
        self.actual = actual
        super.init(callsite: callsite, negative: negative)
    }

    override func evaluate(matcher: Matcher) {
        if (negative && matcher.match(actual)) {
            XCTFail(matcher.negativeFailureMessage(actual), file: callsite.file, line: callsite.line)
        } else if (!negative && !matcher.match(actual)) {
            XCTFail(matcher.failureMessage(actual), file: callsite.file, line: callsite.line)
        }
    }
}
