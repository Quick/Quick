#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import <Quick/Quick-Swift.h>

@interface XCTestSuite (QuickTestSuiteBuilder)
@end

@implementation XCTestSuite (QuickTestSuiteBuilder)

/**
 In order to ensure we can correctly build dynamic test suites, we need to
 replace some of the default test suite constructors.
 */
+ (void)load {
    Method testCaseWithName = class_getClassMethod(self, @selector(testSuiteForTestCaseWithName:));
    Method hooked_testCaseWithName = class_getClassMethod(self, @selector(qck_hooked_testSuiteForTestCaseWithName:));
    method_exchangeImplementations(testCaseWithName, hooked_testCaseWithName);
}

/**
 The `+testSuiteForTestCaseWithName:` method is called when a specific test case
 class is run from the Xcode test navigator. We delegate to `QuickTestSuite` to
 optionally construct a `QuickTestSuiteBuilder` that corresponds to each selected
 test case in the selected test case class. If the test suite builder is `nil`,
 the call to `-buildTestSuite` will be a no-op, and Xcode will not run any tests
 for that test case.

 Given if the following test case class is run from the Xcode test navigator:

    FooSpec
        testFoo
        testBar

 XCTest will invoke this once per test case, with test case names following this format:

    FooSpec/testFoo
    FooSpec/testBar

 It is up to the specific `QuickTestSuiteBuilder` to determine how to build a test
 suite for this sequence of calls.
 */
+ (nullable instancetype)qck_hooked_testSuiteForTestCaseWithName:(nonnull NSString *)name {
    return [[QuickTestSuite selectedTestSuiteForTestCaseWithName:name] buildTestSuite];
}

@end
