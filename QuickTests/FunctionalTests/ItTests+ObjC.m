#import <XCTest/XCTest.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "QCKSpecRunner.h"
#import "Quick/Quick-Swift.h"

QuickSpecBegin(FunctionalTests_ItSpec)

});

QuickSpecEnd

@interface ItTests : XCTestCase; @end

@implementation ItTests

- (void)testAllExamplesAreExecuted {
    XCTestRun *result = qck_runSpec([FunctionalTests_ItSpec class]);
    XCTAssertEqual(result.executionCount, 2);
}

@end
