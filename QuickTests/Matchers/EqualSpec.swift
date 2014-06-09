//
//  EqualSpec.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/9/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Quick

class EqualSpec: QuickSpec {
    override class func exampleGroups() {
        describe("Equal") {
            var matcher: Equal?
            beforeEach { matcher = Equal("Sandor Clegane") }
            describe("failureMessage") {
                it("says it expected actual to be equal to expected") {
                    let message = matcher!.failureMessage("The Hound")
                    expect(message).to.equal("expected 'The Hound' to be equal to 'Sandor Clegane'")
                }
            }

            describe("negativeFailureMessage") {
                it("says it expected actual to not be equal to expected") {
                    let message = matcher!.negativeFailureMessage("Kingsguard")
                    expect(message).to.equal("expected 'Kingsguard' to not be equal to 'Sandor Clegane'")
                }
            }
        }

        describe("equal()") {
            var actual: String?
            var expected: String?
            beforeEach { actual = "Arya Stark" }

            describe("when actual is equal to expected") {
                beforeEach { expected = "Arya Stark" }
                it("matches") {
                    expect(actual!).to.equal(expected!)
                }
            }

            describe("when actual is not equal to expected") {
                beforeEach { expected = "Jaqen H'ghar" }
                it("does not match") {
                    expect(actual!).toNot.equal(expected!)
                }
            }
        }
    }
}
