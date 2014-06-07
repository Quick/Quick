//
//  Contain.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/7/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

class Contain: Matcher {
    override func failureMessage(actual: NSObject) -> String {
        return "expected \(actual) to contain \(expected)"
    }

    override func negativeFailureMessage(actual: NSObject) -> String {
        return "expected \(actual) to contain \(expected)"
    }

    override func match(actual: NSObject) -> Bool {
        if let array = actual as? NSArray {
            return array.containsObject(expected)
        } else if let set = actual as? NSSet {
            return set.containsObject(expected)
        } else {
            return false
        }
    }
}

extension Expectation {
    func contain(expected: NSObject) {
        evaluate(Contain(expected))
    }
}

extension AsynchronousExpectation {
    func contain(expected: NSObject) {
        evaluate(Contain(expected))
    }
}
