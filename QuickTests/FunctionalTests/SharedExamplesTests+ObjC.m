#import <XCTest/XCTest.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "QCKSpecRunner.h"

QuickSpecBegin(FunctionalTests_SharedExamples_Spec)

itBehavesLike(@"a group of three shared examples", ^NSDictionary*{ return @{}; });

QuickSpecEnd

QuickSpecBegin(FunctionalTests_SharedExamples_ContextSpec)

itBehavesLike(@"shared examples that take a context", ^NSDictionary *{
    return @{ @"callsite": @"SharedExamplesSpec" };
});

QuickSpecEnd

QuickSpecBegin(FunctionalTests_SharedExamples_SameContextSpec)

__block NSInteger counter = 0;

afterEach(^{
    counter++;
});

sharedExamples(@"gets called with a different context from within the same spec file", ^(QCKDSLSharedExampleContext exampleContext) {
    
    it(@"tracks correctly", ^{
        NSString *payload = exampleContext()[@"payload"];
        BOOL expected = [payload isEqualToString:[NSString stringWithFormat:@"%ld", (long)counter]];
        expect(@(expected)).to(beTrue());
    });
    
});

itBehavesLike(@"gets called with a different context from within the same spec file", ^{
    return @{ @"payload" : @"0" };
});

itBehavesLike(@"gets called with a different context from within the same spec file", ^{
    return @{ @"payload" : @"1" };
});

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
