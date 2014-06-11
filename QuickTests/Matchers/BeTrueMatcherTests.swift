//
//  BeTrueMatcherTests.swift
//  Quick
//
//  Created by Dave Meehan on 11/06/2014.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import XCTest
import Quick

class BeTrueMatcherTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTrueIsTrue() {

        XCTAssert(BeTrueMatcher().equals(true),
            "should be true")

    }

    func testFalseIsNotTrue() {

        XCTAssertFalse(BeTrueMatcher().equals(false),
            "should be false")
        
    }
}
