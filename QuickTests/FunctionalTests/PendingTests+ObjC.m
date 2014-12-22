#import <XCTest/XCTest.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "QCKSpecRunner.h"

QuickSpecBegin(FunctionalTests_PendingSpec)


QuickSpecEnd

@interface PendingTests : XCTestCase; @end

@implementation PendingTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
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
