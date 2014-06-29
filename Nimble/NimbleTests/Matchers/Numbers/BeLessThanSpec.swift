//
//  BeLessThanSpec.swift
//  Nimble
//
//  Created by Bryan Enders on 6/24/14.
//

import Quick
import Nimble

class BeLessThanSpec: QuickSpec {
    override func spec() {
        describe("BeLessThan") {
            var matcher: BeLessThan! = nil
            beforeEach { matcher = BeLessThan(nil) }

            itBehavesLike("a matcher that complains about nil subjects") { ["matcher": matcher] }

            describe("failureMessage") {
                context("when the subject is not nil") {
                    it("says it expected the subject to be greater than expected") {
                        let message = matcher.failureMessage(0)
                        expect(message).to.equal("expected subject to be less than 'nil', got '0'")
                    }
                }
            }

            describe("negativeFailureMessage") {
                context("when the subject is not nil") {
                    it("says it expected the subject not to be less than expected") {
                        let message = matcher.negativeFailureMessage(-9.98)
                        expect(message).to.equal("expected subject not to be less than 'nil', got '-9.98'")
                    }
                }
            }
        }

        describe("beLessThan()") {
            context("when the subject is not a number") {
                it("doesn't match") {
                    expect("Westeros").notTo.beLessThan(nil)
                }
            }

            context("when the subject is an optional") {
                var subject: NSObject?

                context("and nil") {
                    beforeEach { subject = nil }

                    context("and the expected value is nil") {
                        it("doesn't match") {
                            expect(subject).toNot.beLessThan(nil)
                        }
                    }

                    context("and the expected value is non-nil") {
                        it("doesn't match") {
                            expect(subject).toNot.beLessThan(-20.1)
                        }
                    }
                }

                context("and non-nil") {
                    beforeEach { subject = 0 }

                    context("and it is less than expected") {
                        it("matches") {
                            expect(subject).to.beLessThan(10)
                        }
                    }

                    context("and it is equal to expected") {
                        it("doesn't match") {
                            expect(subject).toNot.beLessThan(subject)
                        }
                    }

                    context("and it is greater than expected") {
                        it("doesn't match") {
                            expect(subject).notTo.beLessThan(-10)
                        }
                    }

                    context("but expected is not a number") {
                        it("doesn't match") {
                            expect(subject).notTo.beLessThan(["Martell": 6])
                        }
                    }
                }
            }

            context("when the subject is not an optional") {
                var subject: NSObject = 5.1

                context("and it is less than expected") {
                    it("matches") {
                        expect(subject).to.beLessThan(6.0)
                    }
                }

                context("and it is equal to expected") {
                    it("doesn't match") {
                        expect(subject).notTo.beLessThan(subject)
                    }
                }

                context("and it is greater than expected") {
                    it("doesn't match") {
                        expect(subject).toNot.beLessThan(4.3)
                    }
                }

                context("but expected is not a number") {
                    it("doesn't match") {
                        expect(subject).notTo.beLessThan([1])
                    }
                }
            }
        }
    }
}
