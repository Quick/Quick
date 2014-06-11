//
//  EqualMatcherTest.swift
//  Quick
//
//  Created by Dave Meehan on 11/06/2014.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import XCTest
import Quick

class EqualMatcherTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBoolTrueIsTrue() {

        XCTAssert(EqualMatcher(true).equals(true),
            "true should be equal to true")

    }

    func testBoolTrueIsNotFalse() {

        XCTAssertFalse(EqualMatcher(true).equals(false),
            "true should not be equal to false")

    }

    func testBoolFalseIsEqualToFalse() {

        XCTAssert(EqualMatcher(false).equals(false),
            "false should be equal to true")

    }

    func testBoolFalseIsNotTrue() {

        XCTAssertFalse(EqualMatcher(false).equals(true),
            "false should not be equal to true")
        
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
}
