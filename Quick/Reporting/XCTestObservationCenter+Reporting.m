//
//  XCTestObservationCenter+Reporting.m
//  Quick
//
//  Created by Paul Young on 1/2/15.
//  Copyright (c) 2015 Brian Ivan Gesiak. All rights reserved.
//

#import "XCTestObservationCenter+Reporting.h"
#import <XCTest/XCTestRun.h>
#import "XCTestDriver.h"

@implementation XCTestObservationCenter (Reporting)

#pragma mark - Test Suites

- (void)_testSuiteDidStart:(XCTestSuiteRun *)run {
    NSString *suiteName = [[run test] name];
    NSString *startDate = [[run startDate] description];
    [[[XCTestDriver sharedTestDriver] IDEProxy] _XCT_testSuite:suiteName didStartAt:startDate];
}

- (void)_testSuiteDidStop:(XCTestSuiteRun *)run {
    NSString *suiteName = [[run test] name];
    NSString *stopDate = [[run stopDate] description];
    NSNumber *executionCount = [NSNumber numberWithUnsignedLong:[run executionCount]];
    NSNumber *failureCount = [NSNumber numberWithUnsignedLong:[run failureCount]];
    NSNumber *unexpectedExceptionCount = [NSNumber numberWithUnsignedLong:[run unexpectedExceptionCount]];
    NSNumber *testDuration = [NSNumber numberWithDouble:[run testDuration]];;
    NSNumber *totalDuration = [NSNumber numberWithDouble:[run totalDuration]];
    
    [[[XCTestDriver sharedTestDriver] IDEProxy] _XCT_testSuite:suiteName didFinishAt:stopDate runCount:executionCount withFailures:failureCount unexpected:unexpectedExceptionCount testDuration:testDuration totalDuration:totalDuration];
}

// There is no obvious equivalent method to call, and it is unclear how to trigger this method.
//- (void)_testSuiteDidFail:(XCTestSuiteRun *)run withDescription:(NSString *)description inFile:(NSString *)file atLine:(NSUInteger)line {
//
//}


#pragma mark - Test Cases

- (void)_testCaseDidStart:(XCTestCaseRun *)run {
    NSString *testName = [[run test] name];
    NSDictionary *components = [self getComponentsFromTestName:testName];
    NSString *testClass = components[@"testClass"];
    NSString *method = components[@"method"];
    
    [[[XCTestDriver sharedTestDriver] IDEProxy] _XCT_testCaseDidStartForTestClass:testClass method:method];
}

- (void)_testCaseDidStop:(XCTestCaseRun *)run {
    NSString *testName = [[run test] name];
    NSDictionary *components = [self getComponentsFromTestName:testName];
    NSString *testClass = components[@"testClass"];
    NSString *method = components[@"method"];
    
    NSString *status = [run hasSucceeded] ? @"passed" : @"failed";
    NSNumber *testDuration = [NSNumber numberWithDouble:[run testDuration]];
    
    [[[XCTestDriver sharedTestDriver] IDEProxy] _XCT_testCaseDidFinishForTestClass:testClass method:method withStatus:status duration:testDuration];
}

- (void)_testCaseDidFail:(XCTestCaseRun *)run withDescription:(NSString *)description inFile:(NSString *)file atLine:(NSUInteger)line {
    NSString *testName = [[run test] name];
    NSDictionary *components = [self getComponentsFromTestName:testName];
    NSString *testClass = components[@"testClass"];
    NSString *method = components[@"method"];
    
    NSNumber *lineNumber = [NSNumber numberWithUnsignedInteger:line];
    
    [[[XCTestDriver sharedTestDriver] IDEProxy] _XCT_testCaseDidFailForTestClass:testClass method:method withMessage:description file:file line:lineNumber];
}

- (void)_testCase:(XCTestCaseRun *)run didMeasureValues:(NSMutableArray *)values forPerformanceMetricID:(NSString *)performanceMetricID name:(NSString *)name unitsOfMeasurement:(NSString *)unitsOfMeasurement baselineName:(NSString *)baselineName baselineAverage:(NSNumber *)baselineAverage maxPercentRegression:(NSNumber *)maxPercentRegression maxPercentRelativeStandardDeviation:(NSNumber *)maxPercentRelativeStandardDeviation maxRegression:(NSNumber *)maxRegression maxStandardDeviation:(NSNumber *)maxStandardDeviation file:(NSString *)file line:(NSUInteger)line {
    NSString *testName = [[run test] name];
    NSDictionary *components = [self getComponentsFromTestName:testName];
    NSString *testClass = components[@"testClass"];
    NSString *method = components[@"method"];
    
    NSNumber *lineNumber = [NSNumber numberWithUnsignedInteger:line];
    
    [[[XCTestDriver sharedTestDriver] IDEProxy] _XCT_testMethod:method ofClass:testClass didMeasureValues:values forPerformanceMetricID:performanceMetricID name:name withUnits:unitsOfMeasurement baselineName:baselineName baselineAverage:baselineAverage maxPercentRegression:maxPercentRegression maxPercentRelativeStandardDeviation:maxPercentRelativeStandardDeviation file:file line:lineNumber];
}


#pragma mark - Helpers

- (NSDictionary *)getComponentsFromTestName:(NSString *)testName {
    NSUInteger location = 2;
    NSUInteger length = [testName length] - location - 1;
    NSRange range = NSMakeRange(location, length);
    NSString *substring = [testName substringWithRange:range];
    NSArray *components = [substring componentsSeparatedByString:@" "];
    
    NSString *testClass = components[0];
    NSString *method = [NSString stringWithFormat:@"%@()", components[1]];
    
    return @{ @"testClass": testClass, @"method": method };
}

@end
