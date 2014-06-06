//
//  FunctionalTests.swift
//  QuickTests
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import XCTest

class PersonSpec: QuickSpec {
    override class var isConcreteSpec: Bool { get { return true } }

    override class func exampleGroups() {
        describe("Person") {
            var person: Person?
            beforeEach { person = Person() }
            afterEach  { person = nil }

            it("is happy") {
                XCTAssert(person!.isHappy, "expected person to be happy by default")
            }

            describe("greeting") {
                context("when the person is unhappy") {
                    beforeEach { person!.isHappy = false }
                    it("is lukewarm") {
                        XCTAssertEqualObjects(person!.greeting, "Oh, hi.", "expected a lukewarm greeting")
                    }
                }

                context("when the person is happy") {
                    beforeEach { person!.isHappy = true }
                    it("is enthusiastic") {
                        XCTAssertEqualObjects(person!.greeting, "Hello!", "expected an enthusiastic greeting")
                    }
                }
            }
        }
    }
}

class PoetSpec: QuickSpec {
    override class var isConcreteSpec: Bool { get { return true } }

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
                        XCTAssertEqualObjects(poet!.greeting, "Woe is me!", "expected a dramatic greeting")
                    }
                }

                context("when the poet is happy") {
                    beforeEach { poet!.isHappy = true }
                    it("is joyous") {
                        XCTAssertEqualObjects(poet!.greeting, "Oh, joyous day!", "expected a joyous greeting")
                    }
                }
            }
        }
    }
}
