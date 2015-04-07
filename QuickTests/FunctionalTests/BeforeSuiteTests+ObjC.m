#import <XCTest/XCTest.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "QCKSpecRunner.h"

static BOOL beforeSuiteWasExecuted = NO;

QuickSpecBegin(FunctionalTests_BeforeSuite_BeforeSuiteSpec)

beforeSuite(^{
    beforeSuiteWasExecuted = YES;
});

QuickSpecEnd

QuickSpecBegin(FunctionalTests_BeforeSuite_Spec)

it(@"is executed after beforeSuite", ^{
    expect(@(beforeSuiteWasExecuted)).to(beTruthy());
});

QuickSpecEnd

@interface BeforeSuiteTests : XCTestCase; @end

@implementation BeforeSuiteTests

- (void)testBeforeSuiteIsExecutedBeforeAnyExamples {
    // Execute the spec with an assertion before the one with a beforeSuite
    NSArray *specs = @[
        [FunctionalTests_BeforeSuite_Spec class],
        [FunctionalTests_BeforeSuite_BeforeSuiteSpec class]
    ];
    XCTestRun *result = qck_runSpecs(specs);
    XCTAssert(result.hasSucceeded);
}

@end
