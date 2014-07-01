//
//  AsyncExpectation.swift
//  Nimble
//
//  Created by Brian Ivan Gesiak on 6/8/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation
import XCTest

class AsyncExpectation: ClosureExpectation {
    var timeOut: NSTimeInterval = 1.0

    override func evaluate(matcher: Matcher) {
        let expirationDate = NSDate(timeIntervalSinceNow: timeOut)
        while true {
            let expired = NSDate.date().compare(expirationDate) != NSComparisonResult.OrderedAscending
            let actual = actualClosure()
            let matched = matcher.match(actual)

            // The semantics of "will" and "will not" differ greatly.
            //
            // We can stop waiting for "will" as soon as we match, even if we have not
            // waited until a time out.
            //
            // "willNot", on the other hand, implies that we never matched,
            // even after waiting until the time out.
            if negative && _shouldEndNegativeWait(expired, matched, matcher.negativeFailureMessage(actual)) ||
                !negative && _shouldEndPositiveWait(expired, matched, matcher.failureMessage(actual)) {
                    break
            }

            NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow:0.01))
        }
    }

    override func evaluateClosure(matcher: Matcher) {
        let expirationDate = NSDate(timeIntervalSinceNow: timeOut)
        while true {
            let expired = NSDate.date().compare(expirationDate) != NSComparisonResult.OrderedAscending
            let matched = matcher.matchClosure(actualClosure)

            if negative && _shouldEndNegativeWait(expired, matched, matcher.negativeFailureMessageForClosure(actualClosure)) ||
                !negative && _shouldEndPositiveWait(expired, matched, matcher.failureMessageForClosure(actualClosure)) {
                    break
            }

            NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow:0.01))
        }
    }

    func _shouldEndPositiveWait(expired: Bool, _ matched: Bool, _ failureMessage: String) -> Bool {
        if matched || expired {
            if !matched {
                fail(failureMessage, callsite: callsite)
            }
            return true
        } else {
            return false
        }
    }

    func _shouldEndNegativeWait(expired: Bool, _ matched: Bool, _ failureMessage: String) -> Bool {
        if expired {
            if matched {
                fail(failureMessage, callsite: callsite)
            }
            return true
        } else {
            return false
        }
    }
}
