//
//  NumberComparisonMatcher.swift
//  Nimble
//
//  Created by Brian Ivan Gesiak on 6/27/14.
//
//

import Foundation

class NumberComparisonMatcher: Matcher {
    let _nilMessage = "expected subject not to be nil"
    let comparisonDescription: String

    init(expected: NSObject?, comparisonDescription: String) {
        self.comparisonDescription = comparisonDescription
        super.init(expected)
    }

    override func failureMessage(actual: NSObject?) -> String {
        return actual
            ? "expected subject to be \(comparisonDescription) '\(expected)', got '\(actual)'"
            : _nilMessage
    }

    override func negativeFailureMessage(actual: NSObject?) -> String {
        return actual
            ? "expected subject not to be \(comparisonDescription) '\(expected)', got '\(actual)'"
            : _nilMessage
    }

    func matchNumber(actual: NSObject?, matches: (actualNumber: NSNumber, expectedNumber: NSNumber) -> Bool) -> Bool {
        if let actualNumber = actual as? NSNumber {
            if let expectedNumber = expected as? NSNumber {
                return matches(actualNumber: actualNumber, expectedNumber: expectedNumber)
            }
        }
        return false
    }
}