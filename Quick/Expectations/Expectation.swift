//
//  Expectation.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import XCTest

//class Prediction<T> {
//    let callsite: Callsite
//    let negative: Bool
//
//    init(callsite: Callsite, negative: Bool) {
//        self.callsite = callsite
//        self.negative = negative
//    }
//
//    func evaluate(matcher: Matcher<T>) {
//        NSException(name: NSInternalInconsistencyException,
//            reason: "Subclasses must override this method", userInfo: nil).raise()
//    }
//}
//
//class Expectation<T>: Prediction<T> {
//    let actual: () -> T
//
//    init(_ actual: () -> T, callsite: Callsite, negative: Bool) {
//        self.actual = actual
//        super.init(callsite: callsite, negative: negative)
//    }
//
//    override func evaluate(matcher: Matcher<T>) {
//        let result = actual()
//        if (negative && matcher.match(result)) {
//            XCTFail(matcher.negativeFailureMessage(result), file: callsite.file, line: callsite.line)
//        } else if (!negative && !matcher.match(result)) {
//            XCTFail(matcher.failureMessage(result), file: callsite.file, line: callsite.line)
//        }
//    }
//}
