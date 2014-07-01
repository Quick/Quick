//
//  RaiseSpec.swift
//  Nimble
//
//  Created by Brian Ivan Gesiak on 7/1/14.
//
//

import Quick
import Nimble

class RaiseSpec: QuickSpec {
    override func spec() {
        describe("Raise") {
            var matcher: Raise! = nil
            beforeEach { matcher = Raise() }

            describe("failureMessage") {
                it("says it expected the closure to raise") {
                    let message = matcher.failureMessageForClosure({nil})
                    expect(message).to.equal("expected subject to raise")
                }
            }

            describe("negativeFailureMessage") {
                it("says it expected the closure not to raise") {
                    let message = matcher.negativeFailureMessageForClosure({nil})
                    expect(message).to.equal("expected subject not to raise")
                }
            }
        }

        describe("raise()") {
            context("when the subject doesn't raise") {
                it("doesn't match") {
                    expect{nil}.notTo.raise()
                }
            }

            context("when the subject raises") {
                it("matches") {
                    expect{
                        NMBRaiseSpecHelper.raise()
                        return nil
                    }.to.raise()
                }
            }
        }

        describe("raise(name:)") {
            var name: String!
            beforeEach { name = NSRangeException }

            context("when the subject doesn't raise") {
                it("doesn't match") {
                    expect{nil}.notTo.raise(name)
                }
            }

            context("when the subject raises, but not with the name we're looking for") {
                it("doesn't match") {
                    expect{
                        NMBRaiseSpecHelper.raiseWithName(NSInternalInconsistencyException)
                        return nil
                    }.notTo.raise(name)
                }
            }

            context("when the subject raises with the name we're looking for") {
                it("matches") {
                    expect{
                        NMBRaiseSpecHelper.raiseWithName(name)
                        return nil
                    }.to.raise(name)
                }
            }
        }

        describe("raise(name:reason:)") {
            var name: String!
            var reason: String!
            beforeEach {
                name = NSRangeException
                reason = "Now you've gone too far!"
            }

            context("when the subject doesn't raise") {
                it("doesn't match") {
                    expect{nil}.notTo.raise(name, reason: reason)
                }
            }

            context("when the subject raises, but not with the name we're looking for") {
                it("doesn't match") {
                    expect{
                        NMBRaiseSpecHelper.raiseWithName(NSInternalInconsistencyException,
                            reason: reason)
                        return nil
                    }.notTo.raise(name, reason: reason)
                }
            }

            context("when the subject raises, but not with the reason we're looking for") {
                it("doesn't match") {
                    expect{
                        NMBRaiseSpecHelper.raiseWithName(name, reason: "Going, going, gone!")
                        return nil
                    }.notTo.raise(name, reason: reason)
                }
            }

            context("when the subject raises, but not with the name or reason we're looking for") {
                it("doesn't match") {
                    expect{
                        NMBRaiseSpecHelper.raiseWithName(NSInternalInconsistencyException, reason: "Going, going, gone!")
                        return nil
                    }.notTo.raise(name, reason: reason)
                }
            }

            context("when the subject raises with the name and reason we're looking for") {
                it("matches") {
                    expect{
                        NMBRaiseSpecHelper.raiseWithName(name, reason: reason)
                        return nil
                    }.to.raise(name, reason: reason)
                }
            }
        }

        describe("raise(name:reason:userInfo:)") {
            var name: String!
            var reason: String!
            var userInfo: NSDictionary!
            beforeEach {
                name = NSRangeException
                reason = "Now you've gone too far!"
                userInfo = ["Jon": "Snow"]
            }

            context("when the subject doesn't raise") {
                it("doesn't match") {
                    expect{nil}.notTo.raise(name, reason: reason, userInfo: userInfo)
                }
            }

            context("when the subject raises, but not with the name we're looking for") {
                it("doesn't match") {
                    expect{
                        NMBRaiseSpecHelper.raiseWithName(NSInternalInconsistencyException,
                            reason: reason, userInfo: userInfo)
                        return nil
                    }.notTo.raise(name, reason: reason, userInfo: userInfo)
                }
            }

            context("when the subject raises, but not with the reason we're looking for") {
                it("doesn't match") {
                    expect{
                        NMBRaiseSpecHelper.raiseWithName(name, reason: "Going, going, gone!",
                            userInfo: userInfo)
                        return nil
                    }.notTo.raise(name, reason: reason, userInfo: userInfo)
                }
            }

            context("when the subject raises, but not with the name, reason, or userInfo we're looking for") {
                it("doesn't match") {
                    expect{
                        NMBRaiseSpecHelper.raiseWithName(NSInternalInconsistencyException,
                            reason: "Going, going, gone!", userInfo: nil)
                        return nil
                    }.notTo.raise(name, reason: reason, userInfo: userInfo)
                }
            }

            context("when the subject raises with the name, reason, and userInfo we're looking for") {
                it("matches") {
                    expect{
                        NMBRaiseSpecHelper.raiseWithName(name, reason: reason, userInfo: userInfo)
                        return nil
                    }.to.raise(name, reason: reason, userInfo: userInfo)
                }
            }
        }
    }
}
