#import <XCTest/XCTest.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "QCKSpecRunner.h"

static NSUInteger specBeforeEachExecutedCount = 0;
static NSUInteger sharedExamplesBeforeEachExecutedCount = 0;

QuickConfigurationBegin(FunctionalTests_SharedExamples_BeforeEachTests_SharedExamples)

+ (void)configure:(Configuration *)configuration {
    sharedExamples(@"a group of three shared examples with a beforeEach in Obj-C",
                   ^(QCKDSLSharedExampleContext context) {
        beforeEach(^{ sharedExamplesBeforeEachExecutedCount += 1; });
        it(@"passes once", ^{});
        it(@"passes twice", ^{});
        it(@"passes three times", ^{});
    });
}

QuickConfigurationEnd

QuickSpecBegin(FunctionalTests_SharedExamples_BeforeEachSpec)

beforeEach(^{ specBeforeEachExecutedCount += 1; });
it(@"executes the spec beforeEach once", ^{});
itBehavesLike(@"a group of three shared examples with a beforeEach in Obj-C",
              ^NSDictionary*{ return @{}; });

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
    qck_runSpec([FunctionalTests_SharedExamples_BeforeEachSpec class]);
    XCTAssertEqual(sharedExamplesBeforeEachExecutedCount, 3);
}

@end
