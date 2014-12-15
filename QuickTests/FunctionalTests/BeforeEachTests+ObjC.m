#import <XCTest/XCTest.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "QCKSpecRunner.h"

typedef NS_ENUM(NSUInteger, BeforeEachType) {
    OuterOne,
    OuterTwo,
    InnerOne,
    InnerTwo,
    InnerThree,
    NoExamples,
};

static NSMutableArray *beforeEachOrder;

QuickSpecBegin(FunctionalTests_BeforeEachSpec);
QuickSpecEnd;

@interface BeforeEachTests : XCTestCase {} @end

@implementation BeforeEachTests

- (void)setUp {
    beforeEachOrder = [NSMutableArray array];
    [super setUp];
}

- (void)tearDown {
    beforeEachOrder = [NSMutableArray array];
    [super tearDown];
}

- (void)testBeforeEachIsExecutedInTheCorrectOrder {
    qck_runSpec([FunctionalTests_BeforeEachSpec class]);
    NSArray *expectedOrder = @[
        // [1] The outer beforeEach closures are executed from top to bottom.
        @(OuterOne), @(OuterTwo),
        // [2] The outer beforeEach closures are executed from top to bottom.
        @(OuterOne), @(OuterTwo),
        // [3] The outer beforeEach closures are executed from top to bottom,
        //     then the innter beforeEach closures are executed from top to bottom.
        @(OuterOne), @(OuterTwo), @(InnerOne), @(InnerTwo), @(InnerThree),
    ];

    XCTAssertEqualObjects(beforeEachOrder, expectedOrder);
}

@end
