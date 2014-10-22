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

XCTestRun *qck_runSpec(Class specClass) {
    [World sharedWorld].isRunningAdditionalSuites = YES;

    XCTestSuite *suite = [XCTestSuite testSuiteForTestCaseClass:specClass];
    XCTestObservationCenter *observationCenter = [XCTestObservationCenter sharedObservationCenter];

    __block XCTestRun *result = nil;
    [observationCenter _suspendObservationForBlock:^{
        result = [suite run];
    }];

    return result;
}
