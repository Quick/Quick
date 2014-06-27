//
//  BeLessThanOrEqualTo.swift
//  Nimble
//
//  Created by Bryan Enders on 6/24/14.
//

import Foundation

class BeLessThanOrEqualTo: NumberComparisonMatcher {
    init(_ expected: NSObject?) {
        super.init(expected: expected, comparisonDescription: "less than or equal to")
    }

    override func match(actual: NSObject?) -> Bool {
        return matchNumber(actual,
            matches: { (actualNumber: NSNumber, expectedNumber: NSNumber) -> Bool in
                return actualNumber.compare(expectedNumber) != NSComparisonResult.OrderedDescending
            })
    }
}

extension Prediction {
    @objc(nmb_beLessThanOrEqualTo:) func beLessThanOrEqualTo(expected: NSObject?) {
        evaluate(BeLessThanOrEqualTo(expected))
    }
}
