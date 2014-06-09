//
//  BeTrueSpec.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/9/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Quick

class BeTrueSpec: QuickSpec {
    override class func exampleGroups() {
        describe("BeTrue") {
            var matcher: BeTrue?
            beforeEach { matcher = BeTrue() }
            describe("failureMessage") {
                it("says it expected the subject to be true") {
                    let message = matcher!.failureMessage("Theon Greyjoy")
                    expect(message).to.equal("expected 'Theon Greyjoy' to be true")
                }
            }

            describe("negativeFailureMessage") {
                it("says it expected the subject to be false") {
                    let message = matcher!.negativeFailureMessage("Reek")
                    expect(message).to.equal("expected 'Reek' to be false")
                }
            }
        }

        describe("beTrue()") {
            it("matches 'true'") {
                expect(true).to.beTrue()
            }

            it("does not match 'false'") {
                expect(false).toNot.beTrue()
            }

            it("does not match arbitrary objects") {
                expect("true").toNot.beTrue()
            }
        }
    }
}