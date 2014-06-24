//
//  BeIdenticalTo.swift
//  Nimble
//
//  Created by Alex Basson on 6/21/14.
//
//

import Foundation

class BeIdenticalTo: Matcher {
    override func failureMessage(actual: NSObject?) -> String {
        return "expected '\(expected)' to be the same instance as '\(actual)'"
    }

    override func negativeFailureMessage(actual: NSObject?) -> String {
        return "expected subject not to be the same instance as '\(expected)'"
    }

    override func match(actual: NSObject?) -> Bool {
        if expected == nil { return false }
        return actual === expected
    }
}

extension Prediction {
    func beIdenticalTo(expected: NSObject?) {
        evaluate(BeIdenticalTo(expected))
    }
}
