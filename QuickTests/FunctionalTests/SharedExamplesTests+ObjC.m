#import <XCTest/XCTest.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "QCKSpecRunner.h"

QuickSpecBegin(FunctionalTests_SharedExamples_Spec)
QuickSpecEnd

QuickSpecBegin(FunctionalTests_SharedExamples_ContextSpec)
QuickSpecEnd

@interface SharedExamplesTests : XCTestCase; @end

@implementation SharedExamplesTests

- (void)testAGroupOfThreeSharedExamplesExecutesThreeExamples {
    XCTestRun *result = qck_runSpec([FunctionalTests_SharedExamples_Spec class]);
    XCTAssert(result.hasSucceeded);
    XCTAssertEqual(result.executionCount, 3);
}

- (void)testSharedExamplesWithContextPassContextToExamples {
    XCTestRun *result = qck_runSpec([FunctionalTests_SharedExamples_ContextSpec class]);
    XCTAssert(result.hasSucceeded);
}

@end
