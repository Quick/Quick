//
//  Expectation.swift
//  Quick
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
        if QuickSpec.hasInvocations() {
            if (negative && matcher.match(actual)) {
                fail(matcher)
            } else if (!negative && !matcher.match(actual)) {
                fail(matcher)
            }
        }
        else {
            it("is wrapping the fail to prevent an exception") {
                self.fail(matcher)
            }
        }
    }
    
    func fail(matcher: Matcher) {
        XCTFail(matcher.negativeFailureMessage(actual), file: callsite.file, line: callsite.line)
    }
}
