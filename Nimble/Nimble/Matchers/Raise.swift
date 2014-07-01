//
//  Raise.swift
//  Nimble
//
//  Created by Brian Ivan Gesiak on 6/30/14.
//
//

import Foundation

class Raise: Matcher {
    init() {
        super.init(nil)
    }

    override func failureMessage(actual: NSObject?) -> String {
        return "expected subject to raise"
    }

    override func negativeFailureMessage(actual: NSObject?) -> String {
        return "expected subject not to raise"
    }

    override func match(actual: NSObject?) -> Bool {
        // A non-closure actual cannot possibly raise
        return false
    }

    override func matchClosure(actualClosure: () -> (NSObject?)) -> Bool {
        return NMBRaise.raises {
            let _ = actualClosure()
        }
    }
}

extension ClosureExpectation {
    @objc(nmb_raise) func raise() {
        evaluateClosure(Raise())
    }
}
