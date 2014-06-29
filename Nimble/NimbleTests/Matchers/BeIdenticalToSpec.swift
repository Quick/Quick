//
//  BeIdenticalToSpec.swift
//  Nimble
//
//  Created by Alex Basson on 6/21/14.
//
//

import Quick
import Nimble

class BeIdenticalToSpec: QuickSpec {
    override func spec() {
        describe("BeIdenticalTo") {
            itBehavesLike("a matcher that complains about nil subjects") {
                ["matcher": BeIdenticalTo(nil)]
            }
        }

        describe("beIdenticalTo()") {
            var expected: NSString?

            context("when actual is an optional") {
                var actual: NSString?

                context("and nil") {
                    beforeEach { actual = nil }
                    context("and expected is nil") {
                        it("does not match") {
                            expect(actual).to.equal(nil)
                            expect(actual).notTo.beIdenticalTo(nil)
                        }
                    }

                    context("but expected is not nil") {
                        it("does not match") {
                            expect(actual).notTo.equal("Mycah")
                            expect(actual).notTo.beIdenticalTo("Mycah")
                        }
                    }
                }

                context("and non-nil") {
                    beforeEach { actual = "Arya Stark" }
                    context("and is the same instance as") {
                        it("matches") {
                            expect(actual).to.equal(actual)
                            expect(actual).to.beIdenticalTo(actual)
                        }
                    }

                    context("and equal to, but not the same instance as, expected") {
                        it("does not match") {
                            expect(actual).to.equal("Arya Stark")
                            expect(actual).notTo.beIdenticalTo("Arya Stark")
                        }
                    }

                    context("but not equal to expected") {
                        it("does not match") {
                            expect(actual).notTo.equal("Jaqen H'ghar")
                            expect(actual).notTo.beIdenticalTo("Jaqen H'ghar")
                        }
                    }
                }
            }

            context("when actual is not an optional") {
                let actual: NSString = "Eddard Stark"

                context("and it is the same instance as expected") {
                    it("matches") {
                        expect(actual).to.equal(actual)
                        expect(actual).to.beIdenticalTo(actual)
                    }
                }

                context("and it is equal to, but not the same instance as, expected") {
                    it("does not match") {
                        expect(actual).to.equal("Eddard Stark")
                        expect(actual).notTo.beIdenticalTo("Eddard Stark")
                    }
                }

                context("and it is not equal to expected") {
                    it("does not match") {
                        expect(actual).notTo.equal("Robert Baratheon")
                        expect(actual).notTo.beIdenticalTo("Robert Baratheon")
                    }
                }
            }
        }
    }
}
