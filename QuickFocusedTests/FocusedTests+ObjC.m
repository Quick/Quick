#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <XCTest/XCTest.h>

#import "QCKSpecRunner.h"

QuickConfigurationBegin(FunctionalTests_SharedExamplesConfiguration)

+ (void)configure:(Configuration *)configuration {
    sharedExamples(@"two passing shared examples (Objective-C)", ^(QCKDSLSharedExampleContext exampleContext) {
        it(@"has an example that passes (4)", ^{});
        it(@"has another example that passes (5)", ^{});
    });
}

QuickConfigurationEnd

QuickSpecBegin(FunctionalTests_FocusedSpec_Focused)

it(@"has an unfocused example that fails, but is never run", ^{ XCTFail(); });
fit(@"has a focused example that passes (1)", ^{});

fdescribe(@"a focused example group", ^{
    it(@"has an example that is not focused, but will be run, and passes (2)", ^{});
    fit(@"has a focused example that passes (3)", ^{});
});

fitBehavesLike(@"two passing shared examples (Objective-C)", ^NSDictionary *{ return @{}; });

QuickSpecEnd

QuickSpecBegin(FunctionalTests_FocusedSpec_Unfocused)

it(@"has an unfocused example thay fails, but is never run", ^{ XCTFail(); });

describe(@"an unfocused example group that is never run", ^{
    beforeEach(^{ [NSException raise:NSInternalInconsistencyException format:@""]; });
    it(@"has an example that fails, but is never run", ^{ XCTFail(); });
});

QuickSpecEnd

@interface FocusedTests: XCTestCase
@end

@implementation FocusedTests

- (void)testOnlyFocusedExamplesAreExecuted {
    XCTestRun *result = qck_runSpecs(@[
        [FunctionalTests_FocusedSpec_Focused class],
        [FunctionalTests_FocusedSpec_Unfocused class]
    ]);
    XCTAssertEqual(result.executionCount, 5);
}

@end
