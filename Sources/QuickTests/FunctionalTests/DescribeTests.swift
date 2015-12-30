//
//  DescribeTests.swift
//  Quick
//
//  Created by Morgan Chen on 12/3/15.
//  Copyright © 2015 Brian Ivan Gesiak. All rights reserved.
//

import XCTest
import Nimble
import Quick

class DescribeTests: XCTestCase {
    
    func testDescribeThrowsIfUsedOutsideOfQuickSpec() {
        expect { describe("this should throw an exception", {}) }.to(raiseException())
    }
    
}
