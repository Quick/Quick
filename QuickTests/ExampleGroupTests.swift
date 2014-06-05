//
//  ExampleGroupTests.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import XCTest

class ExampleGroupTests : XCTestCase {
    func testExampleGroups() {
        var root = ExampleGroup("Person")

        var person: Person?
        root.appendBefore() {
            person = Person()
        }

        var itIsHappy = Example("is happy") {
            XCTAssert(person!.isHappy, "expected person to be happy by default")
        }
        root.appendExample(itIsHappy)

        var whenUnhappy = ExampleGroup("when the person is unhappy")
        whenUnhappy.appendBefore() {
            person!.isHappy = false
        }
        var itGreetsHalfheartedly = Example("greets halfheartedly") {
            XCTAssertEqualObjects(person!.greeting, "Oh, hi.", "expected a halfhearted greeting")
        }
        whenUnhappy.appendExample(itGreetsHalfheartedly)
        root.appendExampleGroup(whenUnhappy)

        var whenHappy = ExampleGroup("when the person is happy")
        var itGreetsEnthusiastically = Example("greets enthusiastically") {
            XCTAssertEqualObjects(person!.greeting, "Hello!", "expected an enthusiastic greeting")
        }
        whenHappy.appendExample(itGreetsEnthusiastically)
        root.appendExampleGroup(whenHappy)

        root.run()
    }
}
