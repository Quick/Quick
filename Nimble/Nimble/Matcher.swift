//
//  Matcher.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

@objc class Matcher {
    let expected: NSObject?
    init(_ expected: NSObject?) {
        self.expected = expected
    }

    func failureMessage(actual: NSObject?) -> String {
        return "expected \(actual) to match \(expected)"
    }

    func negativeFailureMessage(actual: NSObject?) -> String {
        return "expected \(actual) to not match \(expected)"
    }

    func match(actual: NSObject?) -> Bool {
        NSException(name: NSInternalInconsistencyException,
                    reason:"Matchers must override match()",
                    userInfo: nil).raise()
        return false
    }
}