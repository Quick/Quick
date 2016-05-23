@import XCTest;
@import Quick;
@import Nimble;

#import "QCKSpecRunner.h"

static BOOL isBeforeSuiteCalled = NO;
static BOOL isAfterSuiteCalled = NO;
static BOOL isBeforeEachCalled = NO;
static BOOL isAfterEachCalled = NO;

QuickSpecBegin(FunctionalTests_PendingSpec_ObjC)

describe(@"a describe block containing only pending examples", ^{
    beforeSuite(^{ isBeforeSuiteCalled = YES; });
    beforeEach(^{ isBeforeEachCalled = YES; });
    pending(@"an example that will not run", ^{});
    afterEach(^{ isAfterEachCalled = YES; });
    afterSuite(^{ isAfterSuiteCalled = YES; });
});

QuickSpecEnd

QuickSpecBegin(FunctionalTests_PendingBeforeSuite_Spec_ObjC)

it(@"is executed after beforeSuite", ^{
    expect(@(isBeforeSuiteCalled)).to(beTruthy());
});

QuickSpecEnd

QuickSpecBegin(FunctionalTests_PendingAfterSuite_Spec_ObjC)

it(@"is executed before afterSuite", ^{
    expect(@(isAfterSuiteCalled)).to(beFalsy());
});

QuickSpecEnd

@interface PendingTests_ObjC : XCTestCase; @end

@implementation PendingTests_ObjC

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testAnOtherwiseFailingExampleWhenMarkedPendingDoesNotCauseTheSuiteToFail {
    XCTestRun *result = qck_runSpec([FunctionalTests_PendingSpec_ObjC class]);
    XCTAssert(result.hasSucceeded);
}

- (void)testBeforeEachAfterEachAlwaysRunForPendingExamples {
    isBeforeEachCalled = NO;
    isAfterEachCalled = NO;
    
    NSArray *specs = @[
                       [FunctionalTests_PendingSpec_ObjC class],
                       [FunctionalTests_PendingBeforeSuite_Spec_ObjC class],
                       [FunctionalTests_PendingAfterSuite_Spec_ObjC class]
                       ];
    qck_runSpecs(specs);

    XCTAssertEqual(isBeforeEachCalled, YES);
    XCTAssertEqual(isAfterEachCalled, YES);
}

@end
