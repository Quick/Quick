//
//  BeFalse.swift
//  Nimble
//
//  Created by Bryan Enders on 6/18/14.
//

import Foundation

class BeFalse: Equal {
    init() {
        super.init(false)
    }

    override func failureMessage(actual: NSObject?) -> String {
        return "expected subject to be false"
    }

    override func negativeFailureMessage(actual: NSObject?) -> String {
        return "expected subject not to be false"
    }
}

extension Prediction {
    @objc(nmb_beFalse) func beFalse() {
        evaluate(BeFalse())
    }
}
