@import XCTest;
@import Quick;

#import "QCKSpecRunner.h"

typedef NS_ENUM(NSUInteger, ExecutionOrderType) {
    OuterBeforeEachAutoreleasePool,
    OuterAfterEachAutoreleasePool,
    OuterBeforeEach,
    OuterAfterEach,

    InnerBeforeEachAutoreleasePool,
    InnerAfterEachAutoreleasePool,
    InnerBeforeEach,
    InnerAfterEach,

    Example1,
    Example2,

    NoExamples,
};

static NSMutableArray *executionOrder;

QuickSpecBegin(FunctionalTests_AutoreleasepoolSpec_ObjC)

beforeEachAutoreleasepool(^{ [executionOrder addObject:@(OuterBeforeEachAutoreleasePool)]; });
afterEachAutoreleasepool(^{ [executionOrder addObject:@(OuterAfterEachAutoreleasePool)]; });

beforeEach(^{ [executionOrder addObject:@(OuterBeforeEach)]; });
afterEach(^{ [executionOrder addObject:@(OuterAfterEach)]; });

it(@"executes only outer closures [1]", ^{ [executionOrder addObject:@(Example1)]; });

context(@"when there are nested closures", ^{
    beforeEachAutoreleasepool(^{ [executionOrder addObject:@(InnerBeforeEachAutoreleasePool)]; });
    afterEachAutoreleasepool(^{ [executionOrder addObject:@(InnerAfterEachAutoreleasePool)]; });

    beforeEach(^{ [executionOrder addObject:@(InnerBeforeEach)]; });
    afterEach(^{ [executionOrder addObject:@(InnerAfterEach)]; });

    it(@"executes the outer and inner closures [2]", ^{ [executionOrder addObject:@(Example2)]; });
});

context(@"when there are nested closures without examples", ^{
    beforeEachAutoreleasepool(^{ [executionOrder addObject:@(NoExamples)]; });
    afterEachAutoreleasepool(^{ [executionOrder addObject:@(NoExamples)]; });
});

QuickSpecEnd

@interface AutoreleasepoolTests_ObjC : XCTestCase; @end

@implementation AutoreleasepoolTests_ObjC

- (void)setUp {
    executionOrder = [NSMutableArray array];
    [super setUp];
}

- (void)tearDown {
    executionOrder = [NSMutableArray array];
    [super tearDown];
}

- (void)testAutoreleasepoolClosuresOrdering {
    qck_runSpec([FunctionalTests_AutoreleasepoolSpec_ObjC class]);
    NSArray *expectedOrder = @[
        // [1] The outer autoreleasepool closures wrap beforeEach/afterEach closures.
        @(OuterBeforeEachAutoreleasePool), @(OuterBeforeEach),
        @(Example1),
        @(OuterAfterEach), @(OuterAfterEachAutoreleasePool),

        // [2] The nested autoreleasepool closures wrap the nested beforeEach/afterEach closures.
        @(OuterBeforeEachAutoreleasePool), @(InnerBeforeEachAutoreleasePool),
        @(OuterBeforeEach), @(InnerBeforeEach),
        @(Example2),
        @(InnerAfterEach), @(OuterAfterEach),
        @(InnerAfterEachAutoreleasePool), @(OuterAfterEachAutoreleasePool)
   ];

    XCTAssertEqualObjects(executionOrder, expectedOrder);
}

@end
