//
//  True.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

class BeTrue: Matcher {
    init() {
        super.init(true)
    }

    override func failureMessage(actual: Any?) -> String {
        return "expected '\(actual)' to be true"
    }

    override func negativeFailureMessage(actual: Any?) -> String {
        return "expected '\(actual)' to be false"
    }

    override func match(actual: Any?) -> Bool {

        if actual != nil {

            if actual is Bool {

                return actual as Bool

            }

        }

        return false

    }
}

extension Prediction {
    func beTrue() {
        evaluate(BeTrue())
    }
}
