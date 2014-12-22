#import <XCTest/XCTest.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "QCKSpecRunner.h"

static NSUInteger oneExampleBeforeEachExecutedCount = 0;
static NSUInteger onlyPendingExamplesBeforeEachExecutedCount = 0;

QuickSpecBegin(FunctionalTests_PendingSpec)

QuickSpecEnd

@interface PendingTests : XCTestCase; @end

@implementation PendingTests

- (void)setUp {
    [super setUp];
    oneExampleBeforeEachExecutedCount = 0;
    onlyPendingExamplesBeforeEachExecutedCount = 0;
}

- (void)tearDown {
    oneExampleBeforeEachExecutedCount = 0;
    onlyPendingExamplesBeforeEachExecutedCount = 0;
    [super tearDown];
}

- (void)testAnOtherwiseFailingExampleWhenMarkedPendingDoesNotCauseTheSuiteToFail {
    XCTestRun *result = qck_runSpec([FunctionalTests_PendingSpec class]);
    XCTAssert(result.hasSucceeded);
}

- (void)testBeforeEachOnlyRunForEnabledExamples {
    qck_runSpec([FunctionalTests_PendingSpec class]);
    XCTAssertEqual(oneExampleBeforeEachExecutedCount, 1);
}

- (void)testBeforeEachDoesNotRunForContextsWithOnlyPendingExamples {
    qck_runSpec([FunctionalTests_PendingSpec class]);
    XCTAssertEqual(onlyPendingExamplesBeforeEachExecutedCount, 0);
}

@end
