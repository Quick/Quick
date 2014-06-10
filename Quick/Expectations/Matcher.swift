//
//  Matcher.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

class Matcher {
    let expected: Any?
    init(_ expected: Any?) {
        self.expected = expected
    }

    func failureMessage(actual: Any?) -> String {
        return "expected \(actual) to match \(expected)"
    }

    func negativeFailureMessage(actual: Any?) -> String {
        return "expected \(actual) to not match \(expected)"
    }

    func match(actual: Any?) -> Bool {
        NSException(name: NSInternalInconsistencyException,
                    reason:"Matchers must override match()",
                    userInfo: nil).raise()
        return false
    }
}