@import XCTest;
@import Quick;
@import Nimble;

#import "QCKSpecRunner.h"

typedef NS_ENUM(NSUInteger, AfterEachType) {
    OuterOne,   // 0
    OuterTwo,   // 1
    OuterThree, // 2
    InnerOne,   // 3
    InnerTwo,   // 4
    NoExamples, // 5 (you should not ever see this)
};

static NSMutableArray *afterEachOrder;

QuickSpecBegin(FunctionalTests_AfterEachSpec_ObjC)

describe(@"execution order", ^{
    afterEach(^{ [afterEachOrder addObject:@(OuterOne)]; });
    afterEach(^{ [afterEachOrder addObject:@(OuterTwo)]; });
    afterEach(^{ [afterEachOrder addObject:@(OuterThree)]; });

    it(@"executes the outer afterEach closures once, but not before this closure [1]", ^{
        expect(afterEachOrder).to(equal(@[]));
    });

    it(@"executes the outer afterEach closures a second time, but not before this closure [2]", ^{
        expect(afterEachOrder).to(equal(@[@(OuterOne), @(OuterTwo), @(OuterThree)]));
    });

    context(@"when there are nested afterEach", ^{
        afterEach(^{ [afterEachOrder addObject:@(InnerOne)]; });
        afterEach(^{ [afterEachOrder addObject:@(InnerTwo)]; });

        it(@"executes the outer and inner afterEach closures, but not before this closure [3]", ^{
            // The afterEach for the previous two examples should have been run.
            // The list should contain the afterEach for those example, executed from top to bottom.
            expect(afterEachOrder).to(equal(@[
                @(OuterOne), @(OuterTwo), @(OuterThree),
                @(OuterOne), @(OuterTwo), @(OuterThree),
            ]));
        });
    });

    context(@"when there are nested afterEach without examples", ^{
        afterEach(^{ [afterEachOrder addObject:@(NoExamples)]; });
    });
});

describe(@"execution time", ^{
    afterEach(^{
        XCTAssertTrue(NSThread.isMainThread);
    });

    it(@"executes the afterEach on the main thread", ^{});
});

QuickSpecEnd

@interface AfterEachTests_ObjC : XCTestCase; @end

@implementation AfterEachTests_ObjC

- (void)setUp {
    [super setUp];
    afterEachOrder = [NSMutableArray array];
}

- (void)tearDown {
    afterEachOrder = [NSMutableArray array];
    [super tearDown];
}

- (void)testAfterEachIsExecutedInTheCorrectOrder {
    qck_runSpec([FunctionalTests_AfterEachSpec_ObjC class]);
    NSArray *expectedOrder = @[
        // [1] The outer afterEach closures are executed from top to bottom.
        @(OuterOne), @(OuterTwo), @(OuterThree),
        // [2] The outer afterEach closures are executed from top to bottom.
        @(OuterOne), @(OuterTwo), @(OuterThree),
        // [3] The outer afterEach closures are executed from top to bottom,
        //     then the outer afterEach closures are executed from top to bottom.
        @(InnerOne), @(InnerTwo), @(OuterOne), @(OuterTwo), @(OuterThree),
    ];

    XCTAssertEqualObjects(afterEachOrder, expectedOrder);
}

@end
