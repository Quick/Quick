//
//  Expectation.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import XCTest

class Expectation {
    let actual: NSObject
    let callsite: Callsite
    let negative: Bool

    init(_ actual: NSObject, callsite: Callsite, negative: Bool) {
        self.actual = actual
        self.callsite = callsite
        self.negative = negative
    }

    func evaluate(matcher: Matcher) {
        if (negative && matcher.match(actual)) {
            XCTFail(matcher.negativeFailureMessage(actual), file: callsite.file, line: callsite.line)
        } else if (!negative && !matcher.match(actual)) {
            XCTFail(matcher.failureMessage(actual), file: callsite.file, line: callsite.line)
        }
    }
}
