//
//  Expectation.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation
import XCTest

class Expectation {
    let actual: NSObject
    let negative: Bool
    init(_ actual: NSObject, negative: Bool) {
        self.actual = actual
        self.negative = negative
    }

    func evaluate(matcher: Matcher) {
        if (negative && matcher.match(actual)) {
            XCTFail(matcher.negativeFailureMessage(actual))
        } else if (!negative && !matcher.match(actual)) {
            XCTFail(matcher.failureMessage(actual))
        }
    }
}
