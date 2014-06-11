//
//  EqualSpec.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/9/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Quick

//class EqualSpec: QuickSpec {
//    override class func exampleGroups() {
//        describe("Equal") {
//            var matcher: Equal?
//            beforeEach { matcher = Equal("Sandor Clegane") }
//            describe("failureMessage") {
//                it("says it expected actual to be equal to expected") {
//                    let message = matcher!.failureMessage("The Hound")
//                    expect(message).to.equal("expected 'The Hound' to be equal to 'Sandor Clegane'")
//                }
//            }
//
//            describe("negativeFailureMessage") {
//                it("says it expected actual to not be equal to expected") {
//                    let message = matcher!.negativeFailureMessage("Kingsguard")
//                    expect(message).to.equal("expected 'Kingsguard' to not be equal to 'Sandor Clegane'")
//                }
//            }
//        }
//
//        describe("equal()") {
//            var expected: String?
//
//            context("when actual is an optional") {
//                var actual: String?
//
//                context("and nil") {
//                    beforeEach { actual = nil }
//                    context("and expected is nil") {
//                        it("matches") {
//                            expect(actual).to.equal(nil)
//                        }
//                    }
//
//                    context("but expected is not nil") {
//                        it("doesn't match") {
//                            expect(actual).notTo.equal("Mycah")
//                        }
//                    }
//                }
//
//                context("and non-nil") {
//                    beforeEach { actual = "Arya Stark" }
//                    context("and equal to expected") {
//                        it("matches") {
//                            expect(actual).to.equal("Arya Stark")
//                        }
//                    }
//
//                    context("but not equal to expected") {
//                        it("does not match") {
//                            expect(actual).toNot.equal("Jaqen H'ghar")
//                        }
//                    }
//                }
//            }
//
//            context("when actual is not an optional") {
//                let actual = "Eddard Stark"
//
//                context("and it is equal to expected") {
//                    it("matches") {
//                        expect(actual).to.equal("Eddard Stark")
//                    }
//                }
//
//                context("and it is not equal to expected") {
//                    it("does not match") {
//                        expect(actual).toNot.equal("Robert Baratheon")
//                    }
//                }
//            }
//        }
//    }
//}
