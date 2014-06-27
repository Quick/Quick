//
//  BeGreaterThanOrEqualTo.swift
//  Nimble
//
//  Created by Bryan Enders on 6/24/14.
//

import Foundation

class BeGreaterThanOrEqualTo: NumberComparisonMatcher {
    init(_ expected: NSObject?) {
        super.init(expected: expected, comparisonDescription: "greater than or equal to")
    }

    override func match(actual: NSObject?) -> Bool {
        return matchNumber(actual,
            matches: { (actualNumber: NSNumber, expectedNumber: NSNumber) -> Bool in
                return actualNumber.compare(expectedNumber) != NSComparisonResult.OrderedAscending
            })
    }
}

extension Prediction {
    @objc(nmb_beGreaterThanOrEqualTo:) func beGreaterThanOrEqualTo(expected: NSObject?) {
        evaluate(BeGreaterThanOrEqualTo(expected))
    }
}
