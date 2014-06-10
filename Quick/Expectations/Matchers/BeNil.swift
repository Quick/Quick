//
//  Nil.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

class BeNil: Matcher {
    init() {
        super.init(true)
    }

    override func failureMessage(actual: Any?) -> String {
        return "expected '\(actual)' to be nil"
    }

    override func negativeFailureMessage(actual: Any?) -> String {
        return "expected '\(actual)' to be non-nil"
    }

    override func match(actual: Any?) -> Bool {

        return actual == nil
    }
}

extension Prediction {
    func beNil() {
        evaluate(BeNil())
    }
}
