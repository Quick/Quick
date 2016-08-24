//
//  AfterSuiteTests+ObjC.m
//  Quick
//
//  Created by Fujiki Takeshi on 2016/08/24.
//  Copyright © 2016年 Brian Ivan Gesiak. All rights reserved.
//

@import XCTest;
@import Quick;
@import Nimble;

#import "AfterSuiteTestsHeader.h"

@interface AfterSuiteTests_ObjC : QuickSpec

@end

@implementation AfterSuiteTests_ObjC

- (void)spec {
    it(@"is executed before afterSuite", ^{
        expect(@(afterSuiteTestsWasExecuted_ObjC)).to(beFalsy());
    });

    afterSuite(^{
        afterSuiteTestsWasExecuted_ObjC = YES;
    });
}

+ (void)tearDown {
    if (afterSuiteFirstTestExecuted) {
        assert(afterSuiteTestsWasExecuted);
        assert(afterSuiteTestsWasExecuted_ObjC);
    } else {
        afterSuiteFirstTestExecuted = true;
    }
}

@end
