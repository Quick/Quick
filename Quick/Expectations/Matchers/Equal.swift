//
//  Equal.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

class Equal: Matcher {
    override func failureMessage(actual: Any?) -> String {
        return "expected '\(actual)' to be equal to '\(expected)'"
    }

    override func negativeFailureMessage(actual: Any?) -> String {
        return "expected '\(actual)' to not be equal to '\(expected)'"
    }

    override func match(actual: Any?) -> Bool {

        if actual != nil && expected != nil {

            return true

        }
        return false
    }
}

extension Prediction {
    func equal(expected: Any?) {
        evaluate(Equal(expected))
    }
}
