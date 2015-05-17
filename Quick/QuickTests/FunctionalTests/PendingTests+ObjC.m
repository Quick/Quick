#import <XCTest/XCTest.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "QCKSpecRunner.h"

static NSUInteger oneExampleBeforeEachExecutedCount = 0;
static NSUInteger onlyPendingExamplesBeforeEachExecutedCount = 0;

QuickSpecBegin(FunctionalTests_PendingSpec)

pending(@"an example that will not run", ^{
    expect(@YES).to(beFalsy());
});

describe(@"a describe block containing only one enabled example", ^{
    beforeEach(^{ oneExampleBeforeEachExecutedCount += 1; });
    it(@"an example that will run", ^{});
    pending(@"an example that will not run", ^{});
});

describe(@"a describe block containing only pending examples", ^{
    beforeEach(^{ onlyPendingExamplesBeforeEachExecutedCount += 1; });
    pending(@"an example that will not run", ^{});
});

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
