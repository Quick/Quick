//
//  Equal.swift
//  Nimble
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

class Equal: Matcher {
    override func failureMessage(actual: NSObject?) -> String {
        return "expected '\(expected)', got '\(actual)'"
    }

    override func negativeFailureMessage(actual: NSObject?) -> String {
        return "expected subject not to equal '\(expected)'"
    }

    override func match(actual: NSObject?) -> Bool {
        return actual == expected
    }
}

extension Prediction {
    @objc(nmb_equal:) func equal(expected: NSObject?) {
        evaluate(Equal(expected))
    }
}
