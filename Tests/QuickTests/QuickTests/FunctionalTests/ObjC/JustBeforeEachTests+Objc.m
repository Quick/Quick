@import XCTest;
@import Quick;
@import Nimble;

#import "QCKSpecRunner.h"

typedef NS_ENUM(NSUInteger, ApiResponseType) {
    Success,
    Failure
};

@interface SomeApiClass_Objc : XCTestCase; @end

@implementation SomeApiClass_Objc

+ (ApiResponseType)apiCall:(BOOL)someArgument {
    if (someArgument) {
        return Success;
    } else {
        return Failure;
    }
}
@end

static ApiResponseType apiResponse;
static BOOL apiClassArgument = NO;

QuickSpecBegin(FunctionalTests_JustBeforeEachSpec_ObjC)

justBeforeEach(^{
    apiResponse = [SomeApiClass_Objc apiCall:apiClassArgument];
});

context(@"success", ^{
    beforeEach(^{
        apiClassArgument = YES;
    });

    it(@"then it responds with Success", ^{
        expect((NSInteger)apiResponse).to(equal(Success));
    });
});

context(@"failure", ^{
    beforeEach(^{
        apiClassArgument = NO;
    });

    it(@"then it responds with Failure", ^{
        expect((NSInteger)apiResponse).to(equal(Failure));
    });
});

QuickSpecEnd

@interface JustBeforeEachTests_ObjC : XCTestCase; @end

@implementation JustBeforeEachTests_ObjC

- (void)testJustBeforeEachExecuted {
    XCTestRun *result = qck_runSpec([FunctionalTests_JustBeforeEachSpec_ObjC class]);
    XCTAssertEqual(result.executionCount, 2);
    XCTAssertTrue(result.hasSucceeded);
}

@end
