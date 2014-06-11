//
//  Nil.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

class BeNil<T>: Matcher<T> {
    init() {
        super.init(true)
    }

    override func failureMessage(actual: T) -> String {
        return "expected '\(actual)' to be nil"
    }

    override func negativeFailureMessage(actual: T) -> String {
        return "expected '\(actual)' to be non-nil"
    }

    override func match(actual: T) -> Bool {

        return actual == nil
    }
}

extension Prediction {
    func beNil() {
        evaluate(BeNil())
    }
}
