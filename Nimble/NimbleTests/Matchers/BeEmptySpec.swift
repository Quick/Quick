//
//  BeEmptySpec.swift
//  Quick
//
//  Created by Bryan Enders on 6/23/14.
//

import Quick
import Nimble

class BeEmptySpec: QuickSpec {
    override func spec() {

        describe("BeEmpty") {
            var matcher: BeEmpty! = nil
            var subject: NSObject?
            beforeEach { matcher = BeEmpty() }

            let nilMessage = "expected subject not to be nil"

            describe("failureMessage") {
                context("when the subject is nil") {
                    beforeEach { subject = nil }
                    it("says it expected subject not to be nil") {
                        let message = matcher.failureMessage(subject)
                        expect(message).to.equal(nilMessage)
                    }
                }

                context("when the subject is an array") {
                    beforeEach { subject = ["Davos Seaworth", "Gilly"] }
                    it("says it expected subject to be empty") {
                        let message = matcher.failureMessage(subject)
                        expect(message).to.equal("expected subject to be empty, got '[ Davos Seaworth, Gilly ]'")
                    }
                }

                context("when the subject is a set") {
                    beforeEach { subject = NSSet(objects: "Davos Seaworth", "Gilly") }
                    it("says it expected subject to be empty") {
                        let message = matcher.failureMessage(subject)
                        expect(message).to.equal("expected subject to be empty, got '[ Davos Seaworth, Gilly ]'")
                    }
                }

                context("when the subject is a string") {
                    beforeEach { subject = "Samwell Tarly"}
                    it("says it expected subject to be empty") {
                        let message = matcher.failureMessage(subject)
                        expect(message).to.equal("expected subject to be empty, got 'Samwell Tarly'")
                    }
                }
            }

            describe("negativeFailureMessage") {

                let negativeMessage = "expected subject not to be empty"

                context("when the subject is nil") {
                    beforeEach { subject = nil }
                    it("says it expected subject not to be nil") {
                        let message = matcher.negativeFailureMessage(subject)
                        expect(message).to.equal(nilMessage)
                    }
                }

                context("when the subject is an array") {
                    beforeEach { subject = [] }
                    it("says it expected subject not to be empty") {
                        let message = matcher.negativeFailureMessage(subject)
                        expect(message).to.equal(negativeMessage)
                    }
                }

                context("when the subject is a set") {
                    beforeEach { subject = NSSet() }
                    it("says it expected subject not to be empty") {
                        let message = matcher.negativeFailureMessage(subject)
                        expect(message).to.equal(negativeMessage)
                    }
                }

                context("when the subject is a string") {
                    beforeEach { subject = ""}
                    it("says it expected subject not to be empty") {
                        let message = matcher.negativeFailureMessage(subject)
                        expect(message).to.equal(negativeMessage)
                    }
                }
            }
        }

        describe("beEmpty()") {
            context("when the subject is an optional array") {
                var subject: [AnyObject]?

                context("and nil") {
                    it("does not match") {
                        expect(subject).notTo.beEmpty()
                    }
                }

                context("and not nil") {
                    beforeEach { subject = [] }

                    context("and it is empty") {
                        it("matches") {
                            expect(subject).to.beEmpty()
                        }
                    }

                    context("but it is not empty") {
                        beforeEach { subject = ["Daario Naharis"] }
                        it("doesn't match") {
                            expect(subject).toNot.beEmpty()
                        }
                    }
                }
            }

            context("when the subject is an array") {
                var subject = []

                context("and it is empty") {
                    it("matches") {
                        expect(subject).to.beEmpty()
                    }
                }

                context("but it is not empty") {
                    beforeEach { subject = ["Grey Wind", "Lady", "Nymeria", "Summer", "Shaggydog", "Ghost"] }
                    it("doesn't match") {
                        expect(subject).notTo.beEmpty()
                    }
                }
            }

            context("when the subject is an optional set") {
                var subject: NSSet?

                context("and nil") {
                    it("does not match") {
                        expect(subject).toNot.beEmpty()
                    }
                }

                context("and non-nil") {
                    beforeEach { subject = NSSet() }

                    context("and it is empty") {
                        it("matches") {
                            expect(subject).to.beEmpty()
                        }
                    }

                    context("but it is not empty") {
                        beforeEach { subject = NSSet(objects: "Grey Wind", "Lady", "Nymeria", "Summer", "Shaggydog", "Ghost") }
                        it("doesn't match") {
                            expect(subject).notTo.beEmpty()
                        }
                    }
                }
            }

            context("when the subject is a set") {
                var subject = NSSet()

                context("and it is empty") {
                    it("matches") {
                        expect(subject).to.beEmpty()
                    }
                }

                context("but it is not empty") {
                    beforeEach { subject = NSSet(objects: "Daario Naharis") }
                    it("doesn't match") {
                        expect(subject).toNot.beEmpty()
                    }
                }
            }

            context("when subject is a string") {
                var subject = ""

                context("and it is empty") {
                    it("matches") {
                        expect(subject).to.beEmpty()
                    }
                }

                context("but it is not empty") {
                    beforeEach { subject = "Daario Naharis" }
                    it("doesn't match") {
                        expect(subject).notTo.beEmpty()
                    }
                }
            }

            context("when the subject is neither an array nor a set") {
                it("doesn't match") {
                    expect(42).toNot.beEmpty()
                }
            }
        }
    }
}
