@import XCTest;
@import Quick;
@import Nimble;

#import "QuickTests-Swift.h"
#import "QCKSpecRunner.h"

@interface FakeTestIdentifier : NSObject

@property (nonatomic, copy) NSArray *components;

- (instancetype)initWithComponents:(NSArray *)components;

@end

@implementation FakeTestIdentifier

- (instancetype)initWithComponents:(NSArray *)components {
    if ((self = [super init])) {
        self.components = components;
    }
    return self;
}

@end

@interface XCTestSuite (Private_Headers)

/// Starting with Xcode 12.5 XCTest uses `testClassSuitesForTestIdentifiers:` instead of `testSuiteForTestCaseWithName:`
+ (instancetype)testClassSuitesForTestIdentifiers:(id)arg1 skippingTestIdentifiers:(id)arg2 randomNumberGenerator:(long long)arg3;

@end

QuickSpecBegin(FunctionalTests_SimulateTests_Objc)
it(@"example1", ^{});
it(@"example2", ^{});
it(@"example3", ^{});
QuickSpecEnd

// Invoking private methods in Swift is incredibly janky
// this functionality is tested in Objective-C.

QuickSpecBegin(FunctionalTests_SelectedTests_Xcode12_5_ObjC)

beforeEach(^{
    [QuickTestSuite reset];
});

it(@"correctly grabs only the tests specified", ^{
    NSArray *testIdentifiers = @[
        [[FakeTestIdentifier alloc] initWithComponents:@[
            @"FunctionalTests_SimulateTests_Objc",
            @"example1",
        ]]
    ];
    XCTestSuite *suite = [XCTestSuite testClassSuitesForTestIdentifiers:testIdentifiers skippingTestIdentifiers:nil randomNumberGenerator:0];

    expect(suite.tests).to(haveCount(1));
    expect(suite.tests).to(containElementSatisfying(^BOOL(XCTest *test) {
        return [test.name isEqualToString:@"-[FunctionalTests_SimulateTests_Objc example1]"];
    }));
});

it(@"correctly grabs all tests in a test case if no specific test is specified", ^{
    NSArray *testIdentifiers = @[
        [[FakeTestIdentifier alloc] initWithComponents:@[
            @"FunctionalTests_SimulateTests_Objc"
        ]]
    ];
    XCTestSuite *suite = [XCTestSuite testClassSuitesForTestIdentifiers:testIdentifiers skippingTestIdentifiers:nil randomNumberGenerator:0];

    expect(suite.tests).to(haveCount(3));
    expect(suite.tests).to(containElementSatisfying(^BOOL(XCTest *test) {
        return [test.name isEqualToString:@"-[FunctionalTests_SimulateTests_Objc example1]"];
    }));
    expect(suite.tests).to(containElementSatisfying(^BOOL(XCTest *test) {
        return [test.name isEqualToString:@"-[FunctionalTests_SimulateTests_Objc example2]"];
    }));
    expect(suite.tests).to(containElementSatisfying(^BOOL(XCTest *test) {
        return [test.name isEqualToString:@"-[FunctionalTests_SimulateTests_Objc example3]"];
    }));
});

QuickSpecEnd

