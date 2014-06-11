//
//  Equal.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

struct EqualMatcher<T: Equatable> {

    let expected: T

    init(_ expected: T) {

        self.expected = expected

    }

    func equals(actual: T) -> Bool {

        return expected == actual

    }
}


//class Equal<T>: Matcher<T> {
//    override func failureMessage(actual: T) -> String {
//        return "expected '\(actual)' to be equal to '\(expected)'"
//    }
//
//    override func negativeFailureMessage(actual: T) -> String {
//        return "expected '\(actual)' to not be equal to '\(expected)'"
//    }
//
//    override func match(actual: T) -> Bool {
//        return actual == expected
//    }
//}
//
//extension Prediction {
//    func equal<T>(expected: T) {
//        evaluate(Equal(expected))
//    }
//}
