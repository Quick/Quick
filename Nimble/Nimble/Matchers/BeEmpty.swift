//
//  BeEmpty.swift
//  Quick
//
//  Created by Bryan Enders on 6/23/14.
//

import Foundation

class BeEmpty: Matcher {
    let _nilMessage = "expected subject not to be nil"

    init() {
        super.init(0)
    }

    override func failureMessage(actual: NSObject?) -> String {
        return actual
            ? "expected subject to be empty, got '\(actual?.nmb_flatten())'"
            : _nilMessage
    }

    override func negativeFailureMessage(actual: NSObject?) -> String {
        return actual
            ? "expected subject not to be empty"
            : _nilMessage
    }

    override func match(actual: NSObject?) -> Bool {
        if let x = actual {
            switch x {
            case let array as NSArray:
                return array.count == expected
            case let set as NSSet:
                return set.count == expected
            case let string as NSString:
                return string.length == expected
            default:
                break
            }
        }

        return false
    }
}

extension Prediction {
    @objc(nmb_beEmpty) func beEmpty() {
        evaluate(BeEmpty())
    }
}
