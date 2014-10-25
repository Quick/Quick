//
//  QCKSpecRunner.m
//  Quick
//
//  Created by Brian Gesiak on 10/18/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

#import "QCKSpecRunner.h"
#import "XCTestObservationCenter.h"

#import <Quick/Quick.h>

XCTestRun *qck_runSuite(XCTestSuite *suite) {
    [World sharedWorld].isRunningAdditionalSuites = YES;

    __block XCTestRun *result = nil;
    [[XCTestObservationCenter sharedObservationCenter] _suspendObservationForBlock:^{
        result = [suite run];
    }];
    return result;
}

XCTestRun *qck_runSpec(Class specClass) {
    return qck_runSuite([XCTestSuite testSuiteForTestCaseClass:specClass]);
}

XCTestRun *qck_runSpecs(NSArray *specClasses) {
    XCTestSuite *suite = [XCTestSuite testSuiteWithName:@"MySpecs"];
    for (Class specClass in specClasses) {
        [suite addTest:[XCTestSuite testSuiteForTestCaseClass:specClass]];
    }

    return qck_runSuite(suite);
}
