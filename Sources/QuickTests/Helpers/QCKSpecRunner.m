@import Quick;

#import "QCKSpecRunner.h"
#import "XCTestObservationCenter+QCKSuspendObservation.h"
#import "World.h"

@interface XCTest (Redeclaration)
- (XCTestRun *)run;
@end

XCTestRun *qck_runSuite(XCTestSuite *suite) {
    [World sharedWorld].isRunningAdditionalSuites = YES;

    __block XCTestRun *result = nil;
    [[XCTestObservationCenter sharedTestObservationCenter] qck_suspendObservationForBlock:^{
        if ([suite respondsToSelector:@selector(runTest)]) {
            [suite runTest];
            result = suite.testRun;
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            result = [suite run];
#pragma clang diagnostic pop
        }
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
