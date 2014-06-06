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
    init(_ actual: NSObject) {
        self.actual = actual
    }

    func evaluate(matcher: Matcher) {
        if (!matcher.match(actual)) {
            XCTFail(matcher.failureMessage(actual))
        }
    }
}

class NegativeExpectation: Expectation {
    override func evaluate(matcher: Matcher) {
        if (matcher.match(actual)) {
            XCTFail(matcher.negativeFailureMessage(actual))
        }
    }
}