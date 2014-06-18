//
//  BeFalse.swift
//  Quick
//
//  Created by Bryan Enders on 6/18/14.
//

import Foundation

class BeFalse: Matcher {
    init() {
        super.init(false)
    }
    
    override func failureMessage(actual: NSObject?) -> String {
        return "expected '\(actual)' to be false"
    }
    
    override func negativeFailureMessage(actual: NSObject?) -> String {
        return "expected '\(actual)' to be true"
    }
    
    override func match(actual: NSObject?) -> Bool {
        return actual && actual! == false
    }
}

extension Prediction {
    func beFalse() {
        evaluate(BeFalse())
    }
}
