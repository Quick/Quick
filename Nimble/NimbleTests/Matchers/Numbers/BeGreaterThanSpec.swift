//
//  BeGreaterThanSpec.swift
//  Nimble
//
//  Created by Bryan Enders on 6/24/14.
//

import Quick
import Nimble

class BeGreaterThanSpec: QuickSpec {
    override func spec() {
        describe("BeGreaterThan") {
            var matcher: BeGreaterThan! = nil
            beforeEach { matcher = BeGreaterThan(29) }

            itBehavesLike("a matcher that complains about nil subjects") {
                ["matcher": BeGreaterThan(nil)]
            }

            describe("failureMessage") {
                context("when the subject is not nil") {
                    it("says it expected the subject to be greater than expected") {
                        let message = matcher.failureMessage(12.21)
                        expect(message).to.equal("expected subject to be greater than '29', got '12.21'")
                    }
                }
            }

            describe("negativeFailureMessage") {
                context("when the subject is not nil") {
                    it("says it expected the subject not to be greater than or equal to expected") {
                        let message = matcher.negativeFailureMessage(72)
                        expect(message).to.equal("expected subject not to be greater than '29', got '72'")
                    }
                }
            }
        }

        describe("beGreaterThan()") {
            context("when the subject is not a number") {
                it("doesn't match") {
                    expect("Brienne of Tarth").notTo.beGreaterThan("Brienne of Tarth")
                }
            }

            context("when the subject is an optional") {
                var subject: NSObject?

                context("and nil") {
                    beforeEach { subject = nil }

                    context("and the expected value is nil") {
                        it("doesn't match") {
                            expect(subject).toNot.beGreaterThan(nil)
                        }
                    }

                    context("and the expected value is non-nil") {
                        it("doesn't match") {
                            expect(subject).toNot.beGreaterThan(-20.1)
                        }
                    }
                }

                context("and non-nil") {
                    beforeEach { subject = 8675309 }

                    context("and it is greater than expected") {
                        it("matches") {
                            expect(subject).to.beGreaterThan(7)
                        }
                    }

                    context("and it is equal to expected") {
                        it("doesn't match") {
                            expect(subject).toNot.beGreaterThan(subject)
                        }
                    }

                    context("and it is less than expected") {
                        it("doesn't match") {
                            expect(subject).notTo.beGreaterThan(86753098675309)
                        }
                    }

                    context("but expected is not a number") {
                        it("doesn't match") {
                            expect(subject).notTo.beGreaterThan("Jeor Mormont")
                        }
                    }
                }
            }

            context("when the subject is not an optional") {
                var subject: NSObject = 7.0

                context("and it is greater than expected") {
                    it("matches") {
                        expect(subject).to.beGreaterThan(6.0)
                    }
                }

                context("and it is equal to expected") {
                    it("doesn't match") {
                        expect(subject).notTo.beGreaterThan(subject)
                    }
                }

                context("and it is less than expected") {
                    it("doesn't match") {
                        expect(subject).toNot.beGreaterThan(8.0)
                    }
                }

                context("but expected is not a number") {
                    it("doesn't match") {
                        expect(subject).notTo.beGreaterThan([1, 2, 4])
                    }
                }
            }
        }
    }
}
