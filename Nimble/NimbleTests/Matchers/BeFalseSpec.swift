//
//  BeFalseSpec.swift
//  Quick
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
                    let message = matcher.failureMessage("Antoine Roquentin")
                    expect(message).to.equal("expected 'Antoine Roquentin' to be false")
                }
            }
            
            describe("negativeFailureMessage") {
                it("says it expected the subject to be true") {
                    let message = matcher.negativeFailureMessage("the Autodidact")
                    expect(message).to.equal("expected 'the Autodidact' to be true")
                }
            }
        }
        
        describe("beFalse()") {
            context("when the subject is an optional") {
                var subject: NSObject?
                
                context("and nil") {
                    beforeEach { subject = nil }
                    it("does not match") {
                        expect(subject).toNot.beFalse()
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
                        beforeEach { subject = "Anny" }
                        it("does not match") {
                            expect(subject).toNot.beFalse()
                        }
                    }
                }
            }
            
            context("when the subject is not an optional") {
                it("matches 'false'") {
                    expect(false).to.beFalse()
                }
                
                it("does not match 'true'") {
                    expect(true).toNot.beFalse()
                }
                
                it("does not match arbitrary objects") {
                    expect("false").toNot.beFalse()
                }
            }
        }
    }
}
