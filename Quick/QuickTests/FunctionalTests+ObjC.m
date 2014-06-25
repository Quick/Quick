//
//  FunctionalTests+ObjC.m
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/11/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

static BOOL beforeSuiteExecuted_afterSuiteNotYetExecuted = NO;

QuickSpecBegin(FunctionalTestsObjC)

qck_beforeSuite(^{
    beforeSuiteExecuted_afterSuiteNotYetExecuted = YES;
});

qck_afterSuite(^{
    beforeSuiteExecuted_afterSuiteNotYetExecuted = NO;
});

qck_describe(@"a describe block", ^{
    qck_it(@"contains an it block", ^{
        [nmb_expect(@(beforeSuiteExecuted_afterSuiteNotYetExecuted)).to beTrue];
    });

    qck_pending(@"a pending block", ^{
        qck_it(@"contains a failing it block", ^{
            [nmb_expect(@NO).to beTrue];
        });
    });
});

QuickSpecEnd


@interface UnhandledExceptionTestsObjC : QuickSpec
@property (nonatomic) NSException *expected;
@end

@implementation UnhandledExceptionTestsObjC

- (NSException *)expected {
    if (!_expected) {
        _expected = [[NSException alloc] initWithName:@"name" reason:@"reason" userInfo:nil];
    }
    return _expected;
}

- (void)spec {

    qck_describe(@"unexpected exceptions raised during an example", ^{
        qck_it(@"catches unhandled exceptions", ^{
            [self.expected raise];
            XCTFail("expected test execution not to continue after raised exception");
        });
    });

}

- (void)example:(Example *)example failedWithException:(NSException *)exception {
    XCTAssertEqualObjects(exception, self.expected, @"expected captured exception to be identical to the one raised");
}

@end
