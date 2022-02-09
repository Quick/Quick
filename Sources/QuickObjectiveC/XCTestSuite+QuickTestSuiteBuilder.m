#import <XCTest/XCTest.h>
#import <objc/runtime.h>

#if __has_include("Quick-Swift.h")
#import "Quick-Swift.h"
#else
#import <Quick/Quick-Swift.h>
#endif

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
    
    Method testClassSuitesForTestIdentifiers = class_getClassMethod(self, NSSelectorFromString(@"testClassSuitesForTestIdentifiers:skippingTestIdentifiers:randomNumberGenerator:"));
    Method hooked_testClassSuitesForTestIdentifiers = class_getClassMethod(self, @selector(qck_hooked_testClassSuitesForTestIdentifiers:skippingTestIdentifiers:randomNumberGenerator:));
    method_exchangeImplementations(testClassSuitesForTestIdentifiers, hooked_testClassSuitesForTestIdentifiers);
}

/**
 The `+testSuiteForTestCaseWithName:` method is called when a specific test case
 class is run from the Xcode test navigator. If the built test suite is `nil`,
 Xcode will not run any tests for that test case.

 Given if the following test case class is run from the Xcode test navigator:

    FooSpec
        testFoo
        testBar

 XCTest will invoke this once per test case, with test case names following this format:

    FooSpec/testFoo
    FooSpec/testBar
 */
+ (nullable instancetype)qck_hooked_testSuiteForTestCaseWithName:(nonnull NSString *)name {
    NSArray<NSString *> *components = [name componentsSeparatedByString:@"/"];
    return [QuickTestSuite selectedTestSuiteForTestCaseWithName:[components firstObject] testName:[components count] > 1 ? [components lastObject] : nil];
}

/// Starting with Xcode 12.5 XCTest uses `testClassSuitesForTestIdentifiers:` instead of `testSuiteForTestCaseWithName:`
+ (id)qck_hooked_testClassSuitesForTestIdentifiers:(id)arg1 skippingTestIdentifiers:(id)arg2 randomNumberGenerator:(long long)arg3 {
    // Create resulting suite
    XCTestSuite *suite = [[XCTestSuite alloc] initWithName:@"Selected by Quick"];
    
    // Enumerating all XCTTestIdentifiers
    // - `arg1` is _XCTTestIdentifierSet_Set
    // - `testIdentifier` is _XCTTestIdentifier_Double
    for (id testIdentifier in arg1) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        SEL componentsSel = NSSelectorFromString(@"components");
        NSArray<NSString *> *components = [testIdentifier performSelector:componentsSel];
#pragma clang diagnostic pop

        NSString *testCaseName = [components firstObject];
        NSString *testName = nil;
        if ([components count] > 1) {
            testName = [components lastObject];
        }
        
        // Get suite for current XCTTestIdentifier
        QuickTestSuite *quickSuite = [QuickTestSuite selectedTestSuiteForTestCaseWithName:testCaseName testName:testName];
        
        // Add all tests from current XCTTestIdentifier to resulting suite
        for (XCTest *test in quickSuite.tests) {
            [suite addTest:test];
        }
    }
    
    return suite;
}

@end
