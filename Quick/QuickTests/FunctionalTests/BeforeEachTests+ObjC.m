#import <XCTest/XCTest.h>
#import <Quick/Quick.h>

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

QuickSpecBegin(FunctionalTests_BeforeEachSpec)

beforeEach(^{ [beforeEachOrder addObject:@(OuterOne)]; });
beforeEach(^{ [beforeEachOrder addObject:@(OuterTwo)]; });

it(@"executes the outer beforeEach closures once [1]", ^{});
it(@"executes the outer beforeEach closures a second time [2]", ^{});

context(@"when there are nested beforeEach", ^{
    beforeEach(^{ [beforeEachOrder addObject:@(InnerOne)];   });
    beforeEach(^{ [beforeEachOrder addObject:@(InnerTwo)];   });
    beforeEach(^{ [beforeEachOrder addObject:@(InnerThree)]; });

    it(@"executes the outer and inner beforeEach closures [3]", ^{});
});

context(@"when there are nested beforeEach without examples", ^{
    beforeEach(^{ [beforeEachOrder addObject:@(NoExamples)]; });
});

QuickSpecEnd

@interface BeforeEachTests : XCTestCase; @end

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
        //     then the inner beforeEach closures are executed from top to bottom.
        @(OuterOne), @(OuterTwo), @(InnerOne), @(InnerTwo), @(InnerThree),
    ];

    XCTAssertEqualObjects(beforeEachOrder, expectedOrder);
}

@end
