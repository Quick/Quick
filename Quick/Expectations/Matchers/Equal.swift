//
//  Equal.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

extension CInt {

    func __conversion() -> NSObject {

        return UInt(self) as NSObject
    }
}

class EqualMatcher {
    // NB: Swift compiler bug - if T is left unconstrained the compiler will
    // barf, including crashing Xcode if used in a Playground.
    // Workaround: Constrain on NSObject

    let expected: Any

    init(_ expected: Any) {

        self.expected = expected

    }

    func equals<U:Equatable>(actual: U?) -> Bool {

        if let actual = actual {

            return expected as? U == actual

        }

        return false

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
