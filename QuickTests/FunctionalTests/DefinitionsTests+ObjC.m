#import <XCTest/XCTest.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "QCKSpecRunner.h"

static NSMutableArray *fetches;

QuickSpecBegin(FunctionalTests_DefinitionsSpec)

define(@"one", ^NSObject *{ return @1; });

it(@"should evaluate and return the defined variable", ^{
    NSNumber *one = (NSNumber *)fetch(@"one");
    [fetches addObject:one];
    expect(one).to(equal(@1));
});

__block NSNumber *mutatingNumber = @2;
define(@"number", ^NSObject *{ return mutatingNumber; });

it(@"should memoize the value of the first evaluation in each example", ^{
    mutatingNumber = @2;
    NSNumber *firstFetch = (NSNumber *)fetch(@"number");
    [fetches addObject:firstFetch];
    mutatingNumber = @3;
    NSNumber *secondFetch = (NSNumber *)fetch(@"number");
    [fetches addObject:secondFetch];
    expect(secondFetch).to(equal(firstFetch));
});

it(@"should clear memoized values between examples", ^{
    mutatingNumber = @4;
    NSNumber *number = (NSNumber *)fetch(@"number");
    [fetches addObject:number];
    expect(number).to(equal(@4));
});

QuickSpecEnd

@interface DefinitionsTests : XCTestCase; @end

@implementation DefinitionsTests

- (void)setUp {
    [super setUp];
    fetches = [NSMutableArray array];
}

- (void)tearDown {
    fetches = [NSMutableArray array];
    [super tearDown];
}

- (void)testFetchesReturnsTheExpectedValues {
    qck_runSpec([FunctionalTests_DefinitionsSpec class]);
    NSArray *expectedFetches = @[@1, @2, @2, @4];
    XCTAssertEqualObjects(fetches, expectedFetches);
}

@end
