//
//  True.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

class BeTrue: Matcher {
    override func failureMessage(actual: NSObject) -> String {
        return "expected \(actual) to be true"
    }

    override func negativeFailureMessage(actual: NSObject) -> String {
        return "expected \(actual) to be false"
    }

    override func match(actual: NSObject) -> Bool {
        return actual == true
    }
}

extension Expectation {
    func beTrue() {
        evaluate(BeTrue(true))
    }
}

extension AsynchronousExpectation {
    func beTrue() {
        evaluate(BeTrue(true))
    }
}
