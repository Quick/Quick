//
//  BeLessThanOrEqualToSpec.swift
//  Nimble
//
//  Created by Bryan Enders on 6/24/14.
//

import Quick
import Nimble

class BeLessThanOrEqualToSpec: QuickSpec {
    override func spec() {
        describe("BeLessThanOrEqualTo") {
            var matcher: BeLessThanOrEqualTo! = nil
            beforeEach { matcher = BeLessThanOrEqualTo(10) }

            itBehavesLike("a matcher that complains about nil subjects") {
                ["matcher": BeLessThanOrEqualTo(nil)]
            }

            describe("failureMessage") {
                context("when the subject is not nil") {
                    it("says it expected the subject to be less than or equal to expected") {
                        let message = matcher.failureMessage("Davos Seaworth")
                        expect(message).to.equal("expected subject to be less than or equal to '10', got 'Davos Seaworth'")
                    }
                }
            }

            describe("negativeFailureMessage") {
                context("when the subject is not nil") {
                    it("says it expected the subject not to be less than or equal to expected") {
                        let message = matcher.negativeFailureMessage(999)
                        expect(message).to.equal("expected subject not to be less than or equal to '10', got '999'")
                    }
                }
            }
        }

        describe("beLessThanOrEqualTo()") {
            context("when the subject is not a number") {
                it("doesn't match") {
                    expect("Essos").notTo.beLessThanOrEqualTo(nil)
                }
            }

            context("when the subject is an optional") {
                var subject: NSObject?

                context("and nil") {
                    beforeEach { subject = nil }

                    context("and the expected value is nil") {
                        it("doesn't match") {
                            expect(subject).toNot.beLessThanOrEqualTo(nil)
                        }
                    }

                    context("and the expected value is non-nil") {
                        it("doesn't match") {
                            expect(subject).toNot.beLessThanOrEqualTo(12345.6)
                        }
                    }
                }

                context("and non-nil") {
                    beforeEach { subject = 3.5 }

                    context("and it is less than expected") {
                        it("matches") {
                            expect(subject).to.beLessThanOrEqualTo(4.5)
                        }
                    }

                    context("and it is equal to expected") {
                        it("matches") {
                            expect(subject).to.beLessThanOrEqualTo(subject)
                        }
                    }

                    context("and it is greater than expected") {
                        it("doesn't match") {
                            expect(subject).notTo.beLessThanOrEqualTo(0)
                        }
                    }

                    context("but expected is not a number") {
                        it("doesn't match") {
                            expect(subject).notTo.beLessThanOrEqualTo([0: "Tully"])
                        }
                    }
                }
            }

            context("when the subject is not an optional") {
                var subject: NSObject = 10.8

                context("and it is less than expected") {
                    it("matches") {
                        expect(subject).to.beLessThanOrEqualTo(10.9)
                    }
                }

                context("and it is equal to expected") {
                    it("matches") {
                        expect(subject).to.beLessThanOrEqualTo(subject)
                    }
                }

                context("and it is greater than expected") {
                    it("doesn't match") {
                        expect(subject).toNot.beLessThanOrEqualTo(10.7)
                    }
                }

                context("but expected is not a number") {
                    it("doesn't match") {
                        expect(subject).notTo.beLessThanOrEqualTo([10: 10])
                    }
                }
            }
        }
    }
}
