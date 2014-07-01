//
//  Raise.swift
//  Nimble
//
//  Created by Brian Ivan Gesiak on 6/30/14.
//
//

import Foundation

class Raise: Matcher {
    let name: String?
    let reason: String?
    let userInfo: NSDictionary?

    init(name: String? = nil, reason: String? = nil, userInfo: NSDictionary? = nil) {
        self.name = name
        self.reason = reason
        self.userInfo = userInfo
        super.init(nil)
    }

    override func failureMessageForClosure(actualClosure: () -> (NSObject?)) -> String {
        if let exception = NMBRaise.raises({ let _ = actualClosure() }) {
            if name && reason && userInfo {
                return "expected subject to raise '\(name!)' with reason '\(reason!)' and userInfo '\(userInfo!)', got '\(exception)'"
            } else if name && reason {
                return "expected subject to raise '\(name!)' with reason '\(reason!)', got '\(exception)'"
            } else if let exceptionName = name {
                return "expected subject to raise '\(exceptionName)', got '\(exception)'"
            } else {
                return "expected subject to raise"
            }
        } else {
            return "expected subject to raise"
        }
    }

    override func negativeFailureMessageForClosure(actualClosure: () -> (NSObject?)) -> String {
        if name && reason && userInfo {
            return "expected subject not to raise '\(name!)' with reason '\(reason!)' and userInfo '\(userInfo!)'"
        } else if name && reason {
            return "expected subject not to raise '\(name!)' with reason '\(reason!)'"
        } else if let exceptionName = name {
            return "expected subject not to raise '\(exceptionName)'"
        } else {
            return "expected subject not to raise"
        }
    }

    override func match(actual: NSObject?) -> Bool {
        // A non-closure actual cannot possibly raise
        return false
    }

    override func matchClosure(actualClosure: () -> (NSObject?)) -> Bool {
        if let exception = NMBRaise.raises({ let _ = actualClosure() }) {
            if name && reason && userInfo {
                return exception.name == name && exception.reason == reason && exception.userInfo == userInfo
            } else if name && reason {
                return exception.name == name && exception.reason == reason
            } else if let exceptionName = name {
                return exception.name == name
            } else {
                return true
            }
        } else {
            return false
        }
    }
}

extension ClosureExpectation {
    @objc(nmb_raise) func raise() {
        evaluateClosure(Raise())
    }

    @objc(nmb_raiseWithName:) func raise(name: String) {
        evaluateClosure(Raise(name: name))
    }

    @objc(nmb_raiseWithName:reason:) func raise(name: String, reason: String) {
        evaluateClosure(Raise(name: name, reason: reason))
    }

    @objc(nmb_raiseWithName:reason:userInfo:)
    func raise(name: String, reason: String, userInfo: NSDictionary) {
        evaluateClosure(Raise(name: name, reason: reason, userInfo: userInfo))
    }
}
