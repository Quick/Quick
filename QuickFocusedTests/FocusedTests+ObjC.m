#import <Quick/Quick.h>
#import <XCTest/XCTest.h>

QuickSpecBegin(FocusedTests_ObjC)

it(@"fails (but is never run)", ^{ XCTFail(); });

fit(@"passes", ^{});

fdescribe(@"focused examples", ^{
    it(@"passes", ^{});
});

xitBehavesLike(@"failing shared examples", ^NSDictionary *{
    return @{};
});

QuickSpecEnd