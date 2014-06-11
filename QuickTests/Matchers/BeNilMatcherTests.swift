//
//  BeNilMatcherTests.swift
//  Quick
//
//  Created by Dave Meehan on 11/06/2014.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import XCTest
import Quick

class BeNilMatcherTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testNilIsTrue() {

        XCTAssert(BeNilMatcher().equals(nil),
            "nil should be true")
        
    }
    
    func testOptionalUnassignedIsTrue() {

        var optVal: String?

        XCTAssert(BeNilMatcher().equals(optVal),
            "unassigned optional should be true")
        
    }

    func testOptionalAssignedIsFalse() {

        var optVal: String? = "Hello"

        XCTAssertFalse(BeNilMatcher().equals(optVal),
            "should be false with assigned value")

    }

//    func testOptionalUnassignedAnyIsTrue() {
//
//        var optVal: Any?
//
//        XCTAssert(BeNilMatcher().equals(optVal),
//            "unassigned optional Any should be true")
//
//    }

}
