//
//  MatchRegexp.swift
//  Nimble
//
//  Created by Dzianis Lebedzeu on 6/25/14.
//
//

import Foundation

class MatchRegexp: Matcher {
    override func failureMessage(actual: NSObject?) -> String {
        return "expected '\(expected)' to match '\(actual)'"
    }
    
    override func negativeFailureMessage(actual: NSObject?) -> String {
        return "expected '\(actual)' not to match '\(expected)'"
    }
    
    override func match(actual: NSObject?) -> Bool {
        if let regexp = expected as? NSString {
            if let value = actual as? NSString {
                return value.rangeOfString(regexp, options: .RegularExpressionSearch).location != NSNotFound
            }
        }
        return false
    }
}

extension Prediction {
    @objc(nmb_match:) func match(expected: String!) {
        evaluate(MatchRegexp(expected))
    }
}
