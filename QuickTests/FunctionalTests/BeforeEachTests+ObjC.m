#import <XCTest/XCTest.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "QCKSpecRunner.h"


QuickSpecBegin(FunctionalTests_BeforeEachSpec);
QuickSpecEnd;

@interface BeforeEachTests : XCTestCase {} @end

@implementation BeforeEachTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testBeforeEachIsExecutedInTheCorrectOrder {
}

@end
