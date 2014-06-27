//
//  BeFalseSpec.swift
//  Nimble
//
//  Created by Bryan Enders on 6/18/14.
//

import Quick
import Nimble

class BeFalseSpec: QuickSpec {
    override func spec() {
        describe("BeFalse") {
            var matcher: BeFalse! = nil
            beforeEach { matcher = BeFalse() }
            describe("failureMessage") {
                it("says it expected the subject to be false") {
                    let message = matcher.failureMessage("Bronn")
                    expect(message).to.equal("expected subject to be false")
                }
            }

            describe("negativeFailureMessage") {
                it("says it expected the subject not to be false") {
                    let message = matcher.negativeFailureMessage("Cersei Lannister")
                    expect(message).to.equal("expected subject not to be false")
                }
            }
        }

        describe("beFalse()") {
            context("when the subject is an optional") {
                var subject: NSObject?

                context("and nil") {
                    beforeEach { subject = nil }
                    it("does not match") {
                        expect(subject).notTo.beFalse()
                    }
                }

                context("and non-nil") {
                    context("and it is false") {
                        beforeEach { subject = false }
                        it("matches") {
                            expect(subject).to.beFalse()
                        }
                    }

                    context("and is not false") {
                        beforeEach { subject = "Petyr Baelish" }
                        it("does not match") {
                            expect(subject).notTo.beFalse()
                        }
                    }
                }
            }

            context("when the subject is not an optional") {
                it("matches 'false'") {
                    expect(false).to.beFalse()
                }

                it("does not match 'true'") {
                    expect(true).notTo.beFalse()
                }

                it("does not match arbitrary objects") {
                    expect("false").notTo.beFalse()
                }
            }
        }
    }
}
