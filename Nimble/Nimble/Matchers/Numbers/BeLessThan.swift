//
//  BeLessThan.swift
//  Nimble
//
//  Created by Bryan Enders on 6/24/14.
//

import Foundation

class BeLessThan: NumberComparisonMatcher {
    init(_ expected: NSObject?) {
        super.init(expected: expected, comparisonDescription: "less than")
    }

    override func match(actual: NSObject?) -> Bool {
        return matchNumber(actual,
            matches: { (actualNumber: NSNumber, expectedNumber: NSNumber) -> Bool in
                return actualNumber.compare(expectedNumber) == NSComparisonResult.OrderedAscending
            })
    }
}

extension Prediction {
    @objc(nmb_beLessThan:) func beLessThan(expected: NSObject?) {
        evaluate(BeLessThan(expected))
    }
}
