@import Quick;

#if __has_include("QuickTests-Swift.h")
#import "QuickTests-Swift.h"
#elif __has_include("QuickFocusedTests-Swift.h")
#import "QuickFocusedTests-Swift.h"
#endif

#import "QCKSpecRunner.h"

@interface XCTest (Redeclaration)
- (XCTestRun *)run;
@end

XCTestRun * _Nullable qck_runSuite(XCTestSuite * _Nonnull suite) {
    [World sharedWorld].isRunningAdditionalSuites = YES;

    XCTestRun *result = [[XCTestObservationCenter sharedTestObservationCenter]
                         qck_suspendObservationForBlock:^XCTestRun * _Nullable{
                             [suite runTest];
                             return suite.testRun;
                         }];
    return result;
}

XCTestRun *qck_runSpec(Class specClass) {
    return qck_runSuite([XCTestSuite testSuiteForTestCaseClass:specClass]);
}

XCTestRun * _Nullable qck_runSpecs(NSArray * _Nonnull specClasses) {
    XCTestSuite *suite = [XCTestSuite testSuiteWithName:@"MySpecs"];
    for (Class specClass in specClasses) {
        [suite addTest:[XCTestSuite testSuiteForTestCaseClass:specClass]];
    }

    return qck_runSuite(suite);
}
