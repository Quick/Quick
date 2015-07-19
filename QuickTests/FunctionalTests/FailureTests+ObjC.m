#import <XCTest/XCTest.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "QCKSpecRunner.h"

static BOOL isRunningFunctionalTests = NO;

#pragma mark - Spec

QuickSpecBegin(FunctionalTests_FailureSpec)

describe(@"a group of failing examples", ^{
    it(@"passes", ^{
        expect(@YES).to(beTruthy());
    });

    it(@"fails (but only when running the functional tests)", ^{
        expect(@(isRunningFunctionalTests)).to(beFalsy());
    });

    it(@"fails again (but only when running the functional tests)", ^{
        expect(@(isRunningFunctionalTests)).to(beFalsy());
    });
});

QuickSpecEnd

#pragma mark - Tests

@interface FailureTests : XCTestCase; @end

@implementation FailureTests

- (void)setUp {
    [super setUp];
    isRunningFunctionalTests = YES;
}

- (void)tearDown {
    isRunningFunctionalTests = NO;
    [super tearDown];
}

- (void)testFailureSpecHasSucceededIsFalse {
    XCTestRun *result = qck_runSpec([FunctionalTests_FailureSpec class]);
    XCTAssertFalse(result.hasSucceeded);
}

- (void)testFailureSpecExecutedAllExamples {
    XCTestRun *result = qck_runSpec([FunctionalTests_FailureSpec class]);
    XCTAssertEqual(result.executionCount, 3);
}

- (void)testFailureSpecFailureCountIsEqualToTheNumberOfFailingExamples {
    XCTestRun *result = qck_runSpec([FunctionalTests_FailureSpec class]);
    XCTAssertEqual(result.failureCount, 2);
}

@end
