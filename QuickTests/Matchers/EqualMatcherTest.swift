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

    func testOptionalBoolUnassignedIsNotTrue() {

        var optVal: Bool?

        XCTAssertFalse(EqualMatcher(optVal).equals(true),
            "unassigned bool should not match")
        
    }
    
    func testOptionalBoolUnassignedTrueIsNotFalse() {

        var optVal: Bool?

        XCTAssertFalse(EqualMatcher(optVal).equals(false),
            "unassigned bool should not match")
        
    }
    
    func testOptionalBoolTrueIsTrue() {

        var optVal: Bool? = true

        XCTAssert(EqualMatcher(optVal).equals(true),
            "optional bool true should equal true")
        
    }
    
    func testOptionalBoolFalseIsNotTrue() {

        var optVal: Bool? = false

        XCTAssertFalse(EqualMatcher(optVal).equals(true),
            "optional bool false should not be equal true")
        
    }
    
    func testOptionalStringUnassignedIsNotEqual() {

        var optVal: String?

        XCTAssertFalse(EqualMatcher(optVal).equals("Hello"),
            "unassigned optional string is not equal")
        
    }
    
    func testOptionalStringIsEqual() {

        var optVal: String? = "Hello"

        XCTAssert(EqualMatcher(optVal).equals("Hello"),
            "optional string is equal")

    }
    
    func testOptionalStringIsNotEqual() {

        var optVal: String? = "Hello"

        XCTAssertFalse(EqualMatcher(optVal).equals("World"),
            "optional inequal string is not equal")

    }

    func testArrayEmptyIsEqualToArrayEmpty() {

        var arr1: Array<Int> = []
        var arr2: Array<Int> = []

        XCTAssert(EqualMatcher(arr1).equals(arr2),
            "empty array should equal empty array")

    }

    func testArrayIsEqualToArray() {

        var arr1: Array<Int> = [ 1, 2, 3 ]
        var arr2: Array<Int> = [ 1, 2, 3 ]

        XCTAssert(EqualMatcher(arr1).equals(arr2),
            "identical arrays should be equal")
        
    }
    
    func testArrayIsNotEqualToInequalArray() {

        var arr1: Array<Int> = [ 1, 2, 3 ]
        var arr2: Array<Int> = [ 1, 3 ]

        XCTAssertFalse(EqualMatcher(arr1).equals(arr2),
            "inequal arrays should NOT be equal")
        
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
}
