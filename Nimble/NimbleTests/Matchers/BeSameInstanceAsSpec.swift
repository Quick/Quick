//
//  BeSameInstanceAsSpec.swift
//  Nimble
//
//  Created by Alex Basson on 6/21/14.
//
//

import Quick
import Nimble

class BeSameInstanceAsSpec: QuickSpec {
    override func spec() {
        describe("BeSameInstanceAs") {
            var matcher: BeSameInstanceAs! = nil
            beforeEach { matcher = BeSameInstanceAs("Sandor Clegane") }
            describe("failureMessage") {
                it("says it expected the instances to be the same") {
                    let message = matcher.failureMessage("Sandor Clegane")
                    expect(message).to.equal("expected 'Sandor Clegane' to be the same instance as 'Sandor Clegane'")
                }
            }

            describe("negativeFailureMessage") {
                it("says it expected actual to not be the same instance as expected") {
                    let message = matcher.negativeFailureMessage("Kingsguard")
                    expect(message).to.equal("expected subject not to be the same instance as 'Sandor Clegane'")
                }
            }
        }

        describe("beSameInstanceAs()") {
            var expected: NSString?

            context("when actual is an optional") {
                var actual: NSString?

                context("and nil") {
                    beforeEach { actual = nil }
                    context("and expected is nil") {
                        it("does not match") {
                            expect(actual).to.equal(nil)
                            expect(actual).notTo.beSameInstanceAs(nil)
                        }
                    }

                    context("but expected is not nil") {
                        it("does not match") {
                            expect(actual).notTo.equal("Mycah")
                            expect(actual).notTo.beSameInstanceAs("Mycah")
                        }
                    }
                }

                context("and non-nil") {
                    beforeEach { actual = "Arya Stark" }
                    context("and is the same instance as") {
                        it("matches") {
                            expect(actual).to.equal(actual)
                            expect(actual).to.beSameInstanceAs(actual)
                        }
                    }

                    context("and equal to, but not the same instance as, expected") {
                        it("does not match") {
                            expect(actual).to.equal("Arya Stark")
                            expect(actual).notTo.beSameInstanceAs("Arya Stark")
                        }
                    }

                    context("but not equal to expected") {
                        it("does not match") {
                            expect(actual).notTo.equal("Jaqen H'ghar")
                            expect(actual).notTo.beSameInstanceAs("Jaqen H'ghar")
                        }
                    }
                }
            }

            context("when actual is not an optional") {
                let actual: NSString = "Eddard Stark"

                context("and it is the same instance as expected") {
                    it("matches") {
                        expect(actual).to.equal(actual)
                        expect(actual).to.beSameInstanceAs(actual)
                    }
                }

                context("and it is equal to, but not the same instance as, expected") {
                    it("does not match") {
                        expect(actual).to.equal("Eddard Stark")
                        expect(actual).notTo.beSameInstanceAs("Eddard Stark")
                    }
                }

                context("and it is not equal to expected") {
                    it("does not match") {
                        expect(actual).notTo.equal("Robert Baratheon")
                        expect(actual).notTo.beSameInstanceAs("Robert Baratheon")
                    }
                }
            }
        }
    }
}
