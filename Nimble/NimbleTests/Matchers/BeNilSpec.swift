//
//  BeNilSpec.swift
//  Nimble
//
//  Created by Brian Ivan Gesiak on 6/10/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Quick
import Nimble

class BeNilSpec : QuickSpec {
    override func spec() {
        describe("BeNil") {
            var matcher: BeNil! = nil
            beforeEach { matcher = BeNil() }
            describe("failureMessage") {
                it("says it expected the subject to be nil") {
                    let message = matcher.failureMessage("Khal Drogo")
                    expect(message).to.equal("expected nil, got 'Khal Drogo'")
                }
            }

            describe("negativeFailureMessage") {
                it("says it expected the subject not to be nil") {
                    let message = matcher.negativeFailureMessage("Qotho")
                    expect(message).to.equal("expected subject not to be nil")
                }
            }
        }

        describe("beNil()") {
            context("when the subject is an optional") {
                var subject: NSObject?

                context("and nil") {
                    beforeEach { subject = nil }
                    it("matches") {
                        expect(subject).to.beNil()
                    }
                }

                context("and not nil") {
                    beforeEach { subject = NSObject() }
                    it("does not match") {
                        expect(subject).notTo.beNil()
                    }
                }
            }

            context("when the subject is not an optional") {
                let subject = NSObject()

                it("does not match") {
                    expect(subject).toNot.beNil()
                }
            }
        }
    }
}
