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
        return NSString(format: "expected '%@' (%p) to be identical to '%@' (%p)", actual!, actual!, expected!, expected!)
    }

    override func negativeFailureMessage(actual: NSObject?) -> String {
        return NSString(format: "expected '%@' (%p) not to be identical to '%@' (%p)", actual!, actual!, expected!, expected!)
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
