//
//  MatcherSharedExampleGroups.swift
//  Nimble
//
//  Created by Brian Ivan Gesiak on 6/30/14.
//
//

import Quick
import Nimble

class MatcherSharedExamples: QuickSharedExampleGroups {
    override class func sharedExampleGroups() {
        sharedExamples("a matcher that complains about nil subjects") { (sharedExampleContext: SharedExampleContext) in
            describe("failureMessage") {
                context("when the subject is nil") {
                    it("says it expected subject not to be nil") {
                        let matcher = sharedExampleContext()["matcher"] as Matcher
                        let message = matcher.failureMessage(nil)
                        expect(message).to.equal("expected subject not to be nil")
                    }
                }
            }

            describe("negativeFailureMessage") {
                context("when the subject is nil") {
                    it("says it expected subject not to be nil") {
                        let matcher = sharedExampleContext()["matcher"] as Matcher
                        let message = matcher.negativeFailureMessage(nil)
                        expect(message).to.equal("expected subject not to be nil")
                    }
                }
            }
        }
    }
}
