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
    let callsite: Callsite
    let negative: Bool

    init(_ actual: NSObject, callsite: Callsite, negative: Bool) {
        self.actual = actual
        self.callsite = callsite
        self.negative = negative
    }

    func evaluate(matcher: Matcher) {
        let testCase = World.currentExample!.testCase!

        if (negative && matcher.match(actual)) {
            testCase.recordFailureWithDescription(matcher.negativeFailureMessage(actual),
                inFile: callsite.file, atLine: callsite.line, expected: true)
        } else if (!negative && !matcher.match(actual)) {
            testCase.recordFailureWithDescription(matcher.failureMessage(actual),
                inFile: callsite.file, atLine: callsite.line, expected: true)
        }
    }
}
