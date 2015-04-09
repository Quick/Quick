#import "XCTestObservationCenter+Reporting.h"
#import <XCTest/XCTestRun.h>
#import "XCTestDriver.h"
#import <objc/runtime.h>
#import <Quick/Quick-Swift.h>

@implementation XCTestObservationCenter (Reporting)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self qck_swizzleInstanceMethod:@selector(_testSuiteDidStart:) withMethod:@selector(qck_testSuiteDidStart:)];
        [self qck_swizzleInstanceMethod:@selector(_testSuiteDidStop:) withMethod:@selector(qck_testSuiteDidStop:)];
        [self qck_swizzleInstanceMethod:@selector(_testCaseDidStart:) withMethod:@selector(qck_testCaseDidStart:)];
        [self qck_swizzleInstanceMethod:@selector(_testCaseDidStop:) withMethod:@selector(qck_testCaseDidStop:)];
        [self qck_swizzleInstanceMethod:@selector(_testCaseDidFail:withDescription:inFile:atLine:) withMethod:@selector(qck_testCaseDidFail:withDescription:inFile:atLine:)];
        [self qck_swizzleInstanceMethod:@selector(_testCase:didMeasureValues:forPerformanceMetricID:name:unitsOfMeasurement:baselineName:baselineAverage:maxPercentRegression:maxPercentRelativeStandardDeviation:maxRegression:maxStandardDeviation:file:line:) withMethod:@selector(qck_testCase:didMeasureValues:forPerformanceMetricID:name:unitsOfMeasurement:baselineName:baselineAverage:maxPercentRegression:maxPercentRelativeStandardDeviation:maxRegression:maxStandardDeviation:file:line:)];
    });
}

#pragma mark - Test Suites

- (void)qck_testSuiteDidStart:(XCTestSuiteRun *)run {
    if ([World sharedWorld].reporter) {
        if (![self qck_isSuspended]) {
            NSString *suiteName = [[run test] name];
            NSString *startDate = [[run startDate] description];
            [[[XCTestDriver sharedTestDriver] IDEProxy] _XCT_testSuite:suiteName didStartAt:startDate];
            
            [[TestObservationCenter sharedObservationCenter] testSuiteDidStart:run];
        }
    }
    else {
        [self qck_testSuiteDidStart:run];
    }
}

- (void)qck_testSuiteDidStop:(XCTestSuiteRun *)run {
    if ([World sharedWorld].reporter) {
        if (![self qck_isSuspended]) {
            NSString *suiteName = [[run test] name];
            NSString *stopDate = [[run stopDate] description];
            NSNumber *executionCount = [NSNumber numberWithUnsignedLong:[run executionCount]];
            NSNumber *failureCount = [NSNumber numberWithUnsignedLong:[run failureCount]];
            NSNumber *unexpectedExceptionCount = [NSNumber numberWithUnsignedLong:[run unexpectedExceptionCount]];
            NSNumber *testDuration = [NSNumber numberWithDouble:[run testDuration]];;
            NSNumber *totalDuration = [NSNumber numberWithDouble:[run totalDuration]];
            
            [[[XCTestDriver sharedTestDriver] IDEProxy] _XCT_testSuite:suiteName didFinishAt:stopDate runCount:executionCount withFailures:failureCount unexpected:unexpectedExceptionCount testDuration:testDuration totalDuration:totalDuration];
            
            [[TestObservationCenter sharedObservationCenter] testSuiteDidStop:run];
        }
    }
    else {
        [self qck_testSuiteDidStop:run];
    }
}

// There is no obvious equivalent method to call, and it is unclear how to trigger this method.
//- (void)qck_testSuiteDidFail:(XCTestSuiteRun *)run withDescription:(NSString *)description inFile:(NSString *)file atLine:(NSUInteger)line {
//
//}


#pragma mark - Test Cases

- (void)qck_testCaseDidStart:(XCTestCaseRun *)run {
    if ([World sharedWorld].reporter) {
        if (![self qck_isSuspended]) {
            NSString *testName = [[run test] name];
            NSDictionary *components = [self qck_getComponentsFromTestName:testName];
            NSString *testClass = components[@"testClass"];
            NSString *method = components[@"method"];
            
            [[[XCTestDriver sharedTestDriver] IDEProxy] _XCT_testCaseDidStartForTestClass:testClass method:method];
            
            [[TestObservationCenter sharedObservationCenter] testCaseDidStart:run];
        }
    }
    else {
        [self qck_testCaseDidStart:run];
    }
}

- (void)qck_testCaseDidStop:(XCTestCaseRun *)run {
    if ([World sharedWorld].reporter) {
        if (![self qck_isSuspended]) {
            NSString *testName = [[run test] name];
            NSDictionary *components = [self qck_getComponentsFromTestName:testName];
            NSString *testClass = components[@"testClass"];
            NSString *method = components[@"method"];
            
            NSString *status = [run hasSucceeded] ? @"passed" : @"failed";
            NSNumber *testDuration = [NSNumber numberWithDouble:[run testDuration]];
            
            [[[XCTestDriver sharedTestDriver] IDEProxy] _XCT_testCaseDidFinishForTestClass:testClass method:method withStatus:status duration:testDuration];
            
            [[TestObservationCenter sharedObservationCenter] testCaseDidStop:run];
        }
    }
    else {
        [self qck_testCaseDidStop:run];
    }
}

- (void)qck_testCaseDidFail:(XCTestCaseRun *)run withDescription:(NSString *)description inFile:(NSString *)file atLine:(NSUInteger)line {
    if ([World sharedWorld].reporter) {
        if (![self qck_isSuspended]) {
            NSString *testName = [[run test] name];
            NSDictionary *components = [self qck_getComponentsFromTestName:testName];
            NSString *testClass = components[@"testClass"];
            NSString *method = components[@"method"];
            
            NSNumber *lineNumber = [NSNumber numberWithUnsignedInteger:line];
            
            [[[XCTestDriver sharedTestDriver] IDEProxy] _XCT_testCaseDidFailForTestClass:testClass method:method withMessage:description file:file line:lineNumber];
            
            [[TestObservationCenter sharedObservationCenter] testCaseDidFail:run description:description file:file line:line];
        }
    }
    else {
        [self qck_testCaseDidFail:run withDescription:description inFile:file atLine:line];
    }
}

- (void)qck_testCase:(XCTestCaseRun *)run didMeasureValues:(NSMutableArray *)values forPerformanceMetricID:(NSString *)performanceMetricID name:(NSString *)name unitsOfMeasurement:(NSString *)unitsOfMeasurement baselineName:(NSString *)baselineName baselineAverage:(NSNumber *)baselineAverage maxPercentRegression:(NSNumber *)maxPercentRegression maxPercentRelativeStandardDeviation:(NSNumber *)maxPercentRelativeStandardDeviation maxRegression:(NSNumber *)maxRegression maxStandardDeviation:(NSNumber *)maxStandardDeviation file:(NSString *)file line:(NSUInteger)line {
    if ([World sharedWorld].reporter) {
        if (![self qck_isSuspended]) {
            NSString *testName = [[run test] name];
            NSDictionary *components = [self qck_getComponentsFromTestName:testName];
            NSString *testClass = components[@"testClass"];
            NSString *method = components[@"method"];
            
            NSNumber *lineNumber = [NSNumber numberWithUnsignedInteger:line];
            
            [[[XCTestDriver sharedTestDriver] IDEProxy] _XCT_testMethod:method ofClass:testClass didMeasureValues:values forPerformanceMetricID:performanceMetricID name:name withUnits:unitsOfMeasurement baselineName:baselineName baselineAverage:baselineAverage maxPercentRegression:maxPercentRegression maxPercentRelativeStandardDeviation:maxPercentRelativeStandardDeviation file:file line:lineNumber];
            
            // TODO:
            // [[TestObservationCenter sharedObservationCenter] testCaseDidMeasureValues...
        }
    }
    else {
        [self qck_testCase:run didMeasureValues:values forPerformanceMetricID:performanceMetricID name:name unitsOfMeasurement:unitsOfMeasurement baselineName:baselineName baselineAverage:baselineAverage maxPercentRegression:maxPercentRegression maxPercentRelativeStandardDeviation:maxPercentRelativeStandardDeviation maxRegression:maxPercentRelativeStandardDeviation maxStandardDeviation:maxStandardDeviation file:file line:line];
    }
}


#pragma mark - Helpers

+ (void)qck_swizzleInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector {
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (NSDictionary *)qck_getComponentsFromTestName:(NSString *)testName {
    NSUInteger location = 2;
    NSUInteger length = [testName length] - location - 1;
    NSRange range = NSMakeRange(location, length);
    NSString *substring = [testName substringWithRange:range];
    NSArray *components = [substring componentsSeparatedByString:@" "];
    
    NSString *testClass = components[0];
    NSString *method = [NSString stringWithFormat:@"%@()", components[1]];
    
    return @{ @"testClass": testClass, @"method": method };
}

- (BOOL)qck_isSuspended {
    return NO;
    return (BOOL)[self valueForKey:@"_isSuspended"];
}

@end
