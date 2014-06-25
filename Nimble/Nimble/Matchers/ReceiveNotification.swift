//
//  RecieveNotification.swift
//  Nimble
//
//  Created by Dzianis Lebedzeu on 6/18/14.
//
//

import Foundation

class ReceiveNotification : Matcher {

    var _notificationSent = false

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: expected as String, object: nil)
    }
    
    init(_ expected: NSObject?) {
        super.init(expected)

        NSNotificationCenter.defaultCenter().addObserverForName(expected as String,
                                                                object: nil,
                                                                queue: NSOperationQueue.mainQueue(),
                                                                usingBlock: {_ in
            self._notificationSent = true
        })
    }
    override func match(actual: NSObject?) -> Bool {
        return _notificationSent
    }
    
    override func failureMessage(actual: NSObject?) -> String {
        return "expected subject to receive '\(expected)'"
    }
    
    override func negativeFailureMessage(actual: NSObject?) -> String {
        return "expected subject not to receive '\(expected)'"
    }
}

extension AsyncExpectation {
    @objc(nmb_receive:) func receive(expected: String!) {
        evaluate(ReceiveNotification(expected))
    }
}
