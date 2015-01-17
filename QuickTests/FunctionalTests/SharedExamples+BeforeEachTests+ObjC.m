#import <XCTest/XCTest.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "QCKSpecRunner.h"

static NSUInteger specBeforeEachExecutedCount = 0;
static NSUInteger sharedExamplesBeforeEachExecutedCount = 0;

QuickSpecBegin(FunctionalTests_SharedExamples_BeforeEachTests_SharedExamples)
QuickSpecEnd

QuickSpecBegin(FunctionalTests_SharedExamples_BeforeEachSpec)
QuickSpecEnd

@interface SharedExamples_BeforeEachTests : XCTestCase; @end

@implementation SharedExamples_BeforeEachTests

- (void)setUp {
    [super setUp];
    specBeforeEachExecutedCount = 0;
    sharedExamplesBeforeEachExecutedCount = 0;
}

- (void)tearDown {
    specBeforeEachExecutedCount = 0;
    sharedExamplesBeforeEachExecutedCount = 0;
    [super tearDown];
}

- (void)testBeforeEachOutsideOfSharedExamplesExecutedOnceBeforeEachExample {
    qck_runSpec([FunctionalTests_SharedExamples_BeforeEachSpec class]);
    XCTAssertEqual(specBeforeEachExecutedCount, 4);
}

- (void)testBeforeEachInSharedExamplesExecutedOnceBeforeEachSharedExample {
    qck_runSpec([FunctionalTests_SharedExamples_BeforeEachTests_SharedExamples class]);
    XCTAssertEqual(sharedExamplesBeforeEachExecutedCount, 3);
}

@end
