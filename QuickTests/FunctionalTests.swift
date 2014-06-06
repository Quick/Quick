//
//  FunctionalTests.swift
//  QuickTests
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import XCTest

class PersonSpec: QuickSpec {
    override class func isConcreteSpec() -> Bool { return true }

    override class func exampleGroups() {
        describe("Person") {
            var person: Person?
            beforeEach { person = Person() }
            afterEach  { person = nil }

            it("is happy") {
                expect(person!.isHappy).to.beTrue()
            }

            describe("greeting") {
                context("when the person is unhappy") {
                    beforeEach { person!.isHappy = false }
                    it("is lukewarm") {
                        expect(person!.greeting).to.equal("Oh, hi.")
                        expect(person!.greeting).toNot.equal("Hello!")
                    }
                }

                context("when the person is happy") {
                    beforeEach { person!.isHappy = true }
                    it("is enthusiastic") {
                        expect(person!.greeting).to.equal("Hello!")
                        expect(person!.greeting).toNot.equal("Oh, hi.")
                    }
                }
            }
        }
    }
}

class PoetSpec: QuickSpec {
    override class func isConcreteSpec() -> Bool { return true }

    override class func exampleGroups() {
        describe("Poet") {
            // FIXME: Radar worthy? `var poet: Poet?` results in build error:
            //        "Could not find member 'greeting'"
            var poet: Person?
            beforeEach { poet = Poet() }

            describe("greeting") {
                context("when the poet is unhappy") {
                    beforeEach { poet!.isHappy = false }
                    it("is dramatic") {
                        expect(poet!.greeting).to.equal("Woe is me!")
                    }
                }

                context("when the poet is happy") {
                    beforeEach { poet!.isHappy = true }
                    it("is joyous") {
                        expect(poet!.greeting).to.equal("Oh, joyous day!")
                    }
                }
            }
        }
    }
}
