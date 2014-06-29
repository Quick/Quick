//
//  BeGreaterThanOrEqualToSpec.swift
//  Nimble
//
//  Created by Bryan Enders on 6/24/14.
//

import Quick
import Nimble

class BeGreaterThanOrEqualToSpec: QuickSpec {
    override func spec() {
        describe("BeGreaterThanOrEqualTo") {
            var matcher: BeGreaterThanOrEqualTo! = nil
            beforeEach { matcher = BeGreaterThanOrEqualTo(97.78) }

            itBehavesLike("a matcher that complains about nil subjects") {
                ["matcher": BeGreaterThanOrEqualTo(nil)]
            }

            describe("failureMessage") {
                context("when the subject is not nil") {
                    it("says it expected the subject to be greater than or equal to expected") {
                        let message = matcher.failureMessage(12.21)
                        expect(message).to.equal("expected subject to be greater than or equal to '97.78', got '12.21'")
                    }
                }
            }

            describe("negativeFailureMessage") {
                context("when the subject is not nil") {
                    it("says it expected the subject not to be greater than or equal to expected") {
                        let message = matcher.negativeFailureMessage(89)
                        expect(message).to.equal("expected subject not to be greater than or equal to '97.78', got '89'")
                    }
                }
            }
        }

        describe("beGreaterThanOrEqualTo()") {
            context("when the subject is not a number") {
                it("doesn't match") {
                    expect("Night's Watch").notTo.beGreaterThanOrEqualTo("The Crows")
                }
            }

            context("when the subject is an optional") {
                var subject: NSObject?

                context("and nil") {
                    beforeEach { subject = nil }

                    context("and the expected value is nil") {
                        it("doesn't match") {
                            expect(subject).toNot.beGreaterThanOrEqualTo(nil)
                        }
                    }

                    context("and the expected value is non-nil") {
                        it("doesn't match") {
                            expect(subject).toNot.beGreaterThanOrEqualTo(0)
                        }
                    }
                }

                context("and non-nil") {
                    beforeEach { subject = 25 }

                    context("and it is greater than expected") {
                        it("matches") {
                            expect(subject).to.beGreaterThanOrEqualTo(7)
                        }
                    }

                    context("and it is equal to expected") {
                        it("matches") {
                            expect(subject).to.beGreaterThanOrEqualTo(subject)
                        }
                    }

                    context("and it is less than expected") {
                        it("doesn't match") {
                            expect(subject).notTo.beGreaterThanOrEqualTo(100)
                        }
                    }

                    context("but expected is not a number") {
                        it("doesn't match") {
                            expect(subject).notTo.beGreaterThanOrEqualTo(["Frey", "Greyjoy"])
                        }
                    }
                }
            }

            context("when the subject is not an optional") {
                var subject: NSObject = 10.8

                context("and it is greater than expected") {
                    it("matches") {
                        expect(subject).to.beGreaterThanOrEqualTo(10.7)
                    }
                }

                context("and it is equal to expected") {
                    it("matches") {
                        expect(subject).to.beGreaterThanOrEqualTo(subject)
                    }
                }

                context("and it is less than expected") {
                    it("doesn't match") {
                        expect(subject).toNot.beGreaterThanOrEqualTo(10.9)
                    }
                }

                context("but expected is not a number") {
                    it("doesn't match") {
                        expect(subject).notTo.beGreaterThanOrEqualTo("House Arryn")
                    }
                }
            }
        }
    }
}
