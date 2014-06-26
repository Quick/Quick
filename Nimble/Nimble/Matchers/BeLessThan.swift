//
//  BeLessThan.swift
//  Nimble
//
//  Created by Bryan Enders on 6/24/14.
//

import Foundation

class BeLessThan: Matcher {
    let _nilMessage = "expected subject not to be nil"
    
    override func failureMessage(actual: NSObject?) -> String {
        return actual
            ? "expected subject to be < '\(expected)', got '\(actual)'"
            : _nilMessage
    }
    
    override func negativeFailureMessage(actual: NSObject?) -> String {
        return actual
            ? "expected subject not to be < '\(expected)', got '\(actual)'"
            : _nilMessage
    }
    
    override func match(actual: NSObject?) -> Bool {
        if let actualNumber = actual as? NSNumber {
            if let expectedNumber = expected as? NSNumber {
                return actualNumber.compare(expectedNumber) == NSComparisonResult.OrderedAscending
            }
        }
        return false
    }
}

extension Prediction {
    func beLessThan(expected: NSObject?) {
        evaluate(BeLessThan(expected))
    }
}
