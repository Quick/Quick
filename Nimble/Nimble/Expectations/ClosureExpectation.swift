//
//  ClosureExpectation.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/9/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation
import Quick

class ClosureExpectation: Prediction {
    let actualClosure: () -> (NSObject?)

    init(_ actualClosure: () -> NSObject?, callsite: Callsite, negative: Bool) {
        self.actualClosure = actualClosure
        super.init(callsite: callsite, negative: negative)
    }

    override func evaluate(matcher: Matcher) {
        matcher.match(actualClosure())
    }
}
