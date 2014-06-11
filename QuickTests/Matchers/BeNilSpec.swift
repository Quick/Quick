//
//  BeNilSpec.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/10/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Quick

//class BeNilSpec : QuickSpec {
//    override class func exampleGroups() {
//        describe("BeNil") {
//            var matcher: BeNil!
//            beforeEach { matcher = BeNil() }
//            describe("failureMessage") {
//                it("says it expected the subject to be nil") {
//                    let message = matcher.failureMessage("Khal Drogo")
//                    expect(message).to.equal("expected 'Khal Drogo' to be nil")
//                }
//            }
//
//            describe("negativeFailureMessage") {
//                it("says it expected the subject to be non-nil") {
//                    let message = matcher.negativeFailureMessage("Qotho")
//                    expect(message).to.equal("expected 'Qotho' to be non-nil")
//                }
//            }
//        }
//
//        describe("beNil()") {
//            context("when the subject is an optional") {
//                var person: Person?
//
//                context("and nil") {
//                    beforeEach { person = nil }
//                    it("matches") {
//                        expect(person).to.beNil()
//                    }
//                }
//
//                context("and not nil") {
//                    beforeEach { person = Person() }
//                    it("does not match") {
//                        expect(person).notTo.beNil()
//                    }
//                }
//            }
//
//            context("when the subject is not an optional") {
//                let person = Person()
//
//                it("does not match") {
//                    expect(person).notTo.beNil()
//                }
//            }
//        }
//    }
//}
