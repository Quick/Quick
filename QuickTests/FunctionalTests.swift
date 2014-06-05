//
//  FunctionalTests.swift
//  QuickTests
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import XCTest

class FunctionalSpec: QuickSpec {
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
