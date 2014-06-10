//
//  Equal.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

class Equal: Matcher {
    override func failureMessage(actual: NSObject?) -> String {
        return "expected '\(actual)' to be equal to '\(expected)'"
    }

    override func negativeFailureMessage(actual: NSObject?) -> String {
        return "expected '\(actual)' to not be equal to '\(expected)'"
    }

    override func match(actual: NSObject?) -> Bool {
        return actual == expected
    }
}

extension Prediction {
    func equal(expected: NSObject?) {
        evaluate(Equal(expected))
    }
}
