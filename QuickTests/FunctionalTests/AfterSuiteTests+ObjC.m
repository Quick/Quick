#import <XCTest/XCTest.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "QCKSpecRunner.h"

static BOOL afterSuiteWasExecuted = NO;

QuickSpecBegin(FunctionalTests_AfterSuite_AfterSuiteSpec)

afterSuite(^{
    afterSuiteWasExecuted = YES;
});

QuickSpecEnd

QuickSpecBegin(FunctionalTests_AfterSuite_Spec)

it(@"is executed before afterSuite", ^{
    expect(@(afterSuiteWasExecuted)).to(beFalsy());
});

QuickSpecEnd

@interface AfterSuiteTests : XCTestCase; @end

@implementation AfterSuiteTests

- (void)testAfterSuiteIsNotExecutedBeforeAnyExamples {
    // Execute the spec with an assertion after the one with an afterSuite.
    NSArray *specs = @[
        [FunctionalTests_AfterSuite_AfterSuiteSpec class],
        [FunctionalTests_AfterSuite_Spec class]
    ];
    XCTestRun *result = qck_runSpecs(specs);

    // Although this ensures that afterSuite is not called before any
    // examples, it doesn't test that it's ever called in the first place.
    XCTAssert(result.hasSucceeded);
}

@end
