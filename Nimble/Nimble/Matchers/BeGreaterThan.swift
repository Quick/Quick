//
//  BeGreaterThan.swift
//  Nimble
//
//  Created by Bryan Enders on 6/24/14.
//

import Foundation

class BeGreaterThan: NumberComparisonMatcher {
    init(_ expected: NSObject?) {
        super.init(expected: expected, comparisonDescription: "greater than")
    }

    override func match(actual: NSObject?) -> Bool {
        return matchNumber(actual,
            matches: { (actualNumber: NSNumber, expectedNumber: NSNumber) -> Bool in
                return actualNumber.compare(expectedNumber) == NSComparisonResult.OrderedDescending
            })
    }
}

extension Prediction {
    @objc(nmb_beGreaterThan:) func beGreaterThan(expected: NSObject?) {
        evaluate(BeGreaterThan(expected))
    }
}
