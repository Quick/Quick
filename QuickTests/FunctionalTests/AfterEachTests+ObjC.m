#import <XCTest/XCTest.h>
#import <Quick/Quick.h>

#import "QCKSpecRunner.h"


QuickSpecBegin(FunctionalTests_AfterEachSpec)


QuickSpecEnd

@interface AfterEachTests : XCTestCase; @end

@implementation AfterEachTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testBeforeEachIsExecutedInTheCorrectOrder {
    qck_runSpec([FunctionalTests_AfterEachSpec class]);
}

@end
