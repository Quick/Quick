//
//  BeEmpty.swift
//  Quick
//
//  Created by Bryan Enders on 6/23/14.
//

import Foundation

class BeEmpty: Matcher {
    init() {
        super.init(0)
    }
    
    let _nilMessage = "expected subject not to be nil"
    
    override func failureMessage(actual: NSObject?) -> String {
        return actual
            ? "expected subject to be empty, got '\(_flatten(actual))'"
            : _nilMessage
    }
    
    override func negativeFailureMessage(actual: NSObject?) -> String {
        return actual
            ? "expected subject not to be empty"
            : _nilMessage
    }
    
    override func match(actual: NSObject?) -> Bool {
        if let array = actual as? NSArray {
            return array.count == expected
        } else if let set = actual as? NSSet {
            return set.count == expected
        } else if let string = actual as? NSString {
            return string.length == expected
        } else {
            return false
        }
    }
    
    func _flatten(collection: NSObject?) -> String {
        if let array = collection as? NSArray {
            return "[ " + array.componentsJoinedByString(", ") + " ]"
        } else if let set = collection as? NSSet {
            let array = set.allObjects as NSArray
            return "[ " + array.componentsJoinedByString(", ") + " ]"
        } else {
            return "\(collection)"
        }
    }
}

extension Prediction {
    func beEmpty() {
        evaluate(BeEmpty())
    }
}
