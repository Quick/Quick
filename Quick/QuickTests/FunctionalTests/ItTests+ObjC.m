#import <XCTest/XCTest.h>
#import <QuickCore/QuickCore.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "QCKSpecRunner.h"

QuickSpecBegin(FunctionalTests_ItSpec)

__block ExampleMetadata *exampleMetadata = nil;

beforeEach(^{
    exampleMetadata = [[World sharedWorld] currentExampleMetadata];
});

it(@" ", ^{
    expect(exampleMetadata.example.name).to(equal(@" "));
});

it(@"has a description with セレクター名に使えない文字が入っている 👊💥", ^{
    NSString *name = @"has a description with セレクター名に使えない文字が入っている 👊💥";
    expect(exampleMetadata.example.name).to(equal(name));
});

QuickSpecEnd

@interface ItTests : XCTestCase; @end

@implementation ItTests

- (void)testAllExamplesAreExecuted {
    XCTestRun *result = qck_runSpec([FunctionalTests_ItSpec class]);
    XCTAssertEqual(result.executionCount, 2);
}

@end
