//
//  BeTrue.swift
//  Nimble
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

class BeTrue: Equal {
    init() {
        super.init(true)
    }

    override func failureMessage(actual: NSObject?) -> String {
        return "expected subject to be true"
    }

    override func negativeFailureMessage(actual: NSObject?) -> String {
        return "expected subject not to be true"
    }
}

extension Prediction {
    @objc(nmb_beTrue) func beTrue() {
        evaluate(BeTrue())
    }
}
