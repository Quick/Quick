@import XCTest;
@import Quick;
@import Nimble;

#import "QCKSpecRunner.h"

static BOOL afterSuiteWasExecuted = NO;

QuickSpecBegin(FunctionalTests_AfterSuite_AfterSuiteSpec_ObjC)

afterSuite(^{
    afterSuiteWasExecuted = YES;
});

QuickSpecEnd

QuickSpecBegin(FunctionalTests_AfterSuite_Spec_ObjC)

it(@"is executed before afterSuite", ^{
    expect(@(afterSuiteWasExecuted)).to(beFalsy());
});

QuickSpecEnd

@interface AfterSuiteTests_ObjC : XCTestCase; @end

@implementation AfterSuiteTests_ObjC

- (void)testAfterSuiteIsNotExecutedBeforeAnyExamples {
    // Execute the spec with an assertion after the one with an afterSuite.
    NSArray *specs = @[
        [FunctionalTests_AfterSuite_AfterSuiteSpec_ObjC class],
        [FunctionalTests_AfterSuite_Spec_ObjC class]
    ];
    XCTestRun *result = qck_runSpecs(specs);

    // Although this ensures that afterSuite is not called before any
    // examples, it doesn't test that it's ever called in the first place.
    XCTAssert(result.hasSucceeded);
}

@end
