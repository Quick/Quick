//
//  XCTestObservationCenter.h
//  Quick
//
//  Created by Paul Young on 1/1/15.
//  Copyright (c) 2015 Brian Ivan Gesiak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCTestObservationCenter : NSObject

- (void)_testCaseDidFail:(id)arg1 withDescription:(id)arg2 inFile:(id)arg3 atLine:(unsigned long long)arg4;
- (void)_testCase:(id)arg1 didMeasureValues:(id)arg2 forPerformanceMetricID:(id)arg3 name:(id)arg4 unitsOfMeasurement:(id)arg5 baselineName:(id)arg6 baselineAverage:(id)arg7 maxPercentRegression:(id)arg8 maxPercentRelativeStandardDeviation:(id)arg9 maxRegression:(id)arg10 maxStandardDeviation:(id)arg11 file:(id)arg12 line:(unsigned long long)arg13;
- (void)_testCaseDidStop:(id)arg1;
- (void)_testCaseDidStart:(id)arg1;
- (void)_testSuiteDidFail:(id)arg1 withDescription:(id)arg2 inFile:(id)arg3 atLine:(unsigned long long)arg4;
- (void)_testSuiteDidStop:(id)arg1;
- (void)_testSuiteDidStart:(id)arg1;

@end
