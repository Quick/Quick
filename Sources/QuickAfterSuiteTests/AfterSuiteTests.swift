//
//  QuickSampleTests.swift
//  QuickSampleTests
//
//  Created by Fujiki Takeshi on 2016/08/24.
//  Copyright © 2016年 takecian. All rights reserved.
//

import XCTest
import Quick
import Nimble

class AfterSuiteTests: QuickSpec {
    override func spec(){
        afterSuite { 
            afterSuiteTestsWasExecuted = true
        }

        it("is executed before afterSuite") {
            expect(afterSuiteTestsWasExecuted.boolValue).to(beFalsy())
        }
    }

    override class func tearDown() {
        if afterSuiteFirstTestExecuted.boolValue {
            assert(afterSuiteTestsWasExecuted.boolValue, "afterSuiteTestsWasExecuted needs to be true")
            assert(afterSuiteTestsWasExecuted_ObjC.boolValue, "afterSuiteTestsWasExecuted_ObjC needs to be true")
        } else {
            afterSuiteFirstTestExecuted = true
        }
    }
}
