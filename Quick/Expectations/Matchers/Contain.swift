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
        return "expected '[ \(_flatten(actual)) ]' to contain '\(expected)'"
    }

    override func negativeFailureMessage(actual: NSObject) -> String {
        return "expected '[ \(_flatten(actual)) ]' to not contain '\(expected)'"
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

    func _flatten(collection: NSObject) -> String {
        if let array = collection as? NSArray {
            return array.componentsJoinedByString(", ")
        } else if let set = collection as? NSSet {
            let array = set.allObjects as NSArray
            return array.componentsJoinedByString(", ")
        } else {
            return "\(collection)"
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
