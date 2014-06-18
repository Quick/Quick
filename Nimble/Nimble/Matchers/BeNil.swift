//
//  Nil.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

class BeNil: Equal {
    init() {
        // BeNil is equivalent to Equal(nil)
        super.init(nil)
    }

    override func failureMessage(actual: NSObject?) -> String {
        return "expected '\(actual)' to be nil"
    }

    override func negativeFailureMessage(actual: NSObject?) -> String {
        return "expected '\(actual)' to be non-nil"
    }
}

extension Prediction {
    func beNil() {
        evaluate(BeNil())
    }
}
