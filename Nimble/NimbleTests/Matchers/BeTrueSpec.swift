//
//  BeTrueSpec.swift
//  Nimble
//
//  Created by Brian Ivan Gesiak on 6/9/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Quick
import Nimble

class BeTrueSpec: QuickSpec {
    override func spec() {
        describe("BeTrue") {
            var matcher: BeTrue! = nil
            beforeEach { matcher = BeTrue() }
            describe("failureMessage") {
                it("says it expected the subject to be true") {
                    let message = matcher.failureMessage("Theon Greyjoy")
                    expect(message).to.equal("expected subject to be true")
                }
            }

            describe("negativeFailureMessage") {
                it("says it expected the subject not to be true") {
                    let message = matcher.negativeFailureMessage("Reek")
                    expect(message).to.equal("expected subject not to be true")
                }
            }
        }

        describe("beTrue()") {
            context("when the subject is an optional") {
                var subject: NSObject?

                context("and nil") {
                    beforeEach { subject = nil }
                    it("does not match") {
                        expect(subject).notTo.beTrue()
                    }
                }

                context("and non-nil") {
                    context("and it is true") {
                        beforeEach { subject = true }
                        it("matches") {
                            expect(subject).to.beTrue()
                        }
                    }

                    context("and is not true") {
                        beforeEach { subject = "Daenerys Targaryen" }
                        it("does not match") {
                            expect(subject).notTo.beTrue()
                        }
                    }
                }
            }

            context("when the subject is not an optional") {
                it("matches 'true'") {
                    expect(true).to.beTrue()
                }

                it("does not match 'false'") {
                    expect(false).notTo.beTrue()
                }

                it("does not match arbitrary objects") {
                    expect("true").notTo.beTrue()
                }
            }
        }
    }
}
