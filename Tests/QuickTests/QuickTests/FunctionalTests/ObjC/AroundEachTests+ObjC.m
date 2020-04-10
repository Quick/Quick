@import XCTest;
@import Quick;

#import "QCKSpecRunner.h"

typedef NS_ENUM(NSUInteger, AroundEachType) {
    Around0Prefix,
    Around0Suffix,
    Around1Prefix,
    Around1Suffix,
};

static NSMutableArray *aroundEachOrder;

QuickSpecBegin(FunctionalTests_AroundEachSpec_ObjC)

aroundEach(^(QCKDSLEmptyBlock runExample) {
    [aroundEachOrder addObject:@(Around0Prefix)];
    runExample();
    [aroundEachOrder addObject:@(Around0Suffix)];
});
aroundEach(^(QCKDSLEmptyBlock runExample) {
    [aroundEachOrder addObject:@(Around1Prefix)];
    runExample();
    [aroundEachOrder addObject:@(Around1Suffix)];
});

it(@"executes the aroundEach closures in the proper order", ^{});

QuickSpecEnd

@interface AroundEachTests_ObjC : XCTestCase; @end

@implementation AroundEachTests_ObjC

- (void)setUp {
    aroundEachOrder = [NSMutableArray array];
    [super setUp];
}

- (void)tearDown {
    aroundEachOrder = [NSMutableArray array];
    [super tearDown];
}

- (void)testAroundEachIsExecutedInTheCorrectOrder {
    qck_runSpec([FunctionalTests_AroundEachSpec_ObjC class]);
    NSArray *expectedOrder = @[
        @(Around0Prefix), @(Around1Prefix), @(Around1Suffix), @(Around0Suffix)
    ];

     XCTAssertEqualObjects(aroundEachOrder, expectedOrder);
}

@end
