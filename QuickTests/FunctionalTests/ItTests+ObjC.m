#import <XCTest/XCTest.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "QCKSpecRunner.h"

QuickSpecBegin(FunctionalTests_ItSpec)

__block ExampleMetadata *exampleMetadata = nil;
beforeEachWithMetadata(^(ExampleMetadata *metadata) {
    exampleMetadata = metadata;
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
