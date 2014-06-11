//
//  Matcher.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

class Matcher<T> {
    let expected: T
    init(_ expected: T) {
        self.expected = expected
    }

    func failureMessage(actual: T) -> String {
        return "expected \(actual) to match \(expected)"
    }

    func negativeFailureMessage(actual: T) -> String {
        return "expected \(actual) to not match \(expected)"
    }

    func match(actual: T) -> Bool {
        NSException(name: NSInternalInconsistencyException,
                    reason:"Matchers must override match()",
                    userInfo: nil).raise()
        return false
    }
}