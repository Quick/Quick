#import <XCTest/XCTest.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "QCKSpecRunner.h"

QuickSpecBegin(FunctionalTests_BeforeSuite_BeforeSuiteSpec)
QuickSpecEnd

QuickSpecBegin(FunctionalTests_BeforeSuite_Spec)
QuickSpecEnd

@interface BeforeSuiteTests : XCTestCase; @end

@implementation BeforeSuiteTests

- (void)testBeforeSuiteIsExecutedBeforeAnyExamples {
    NSArray *specs = @[
        [FunctionalTests_BeforeSuite_BeforeSuiteSpec class],
        [FunctionalTests_BeforeSuite_Spec class]
    ];
    XCTestRun *result = qck_runSpecs(specs);
    XCTAssert(result.hasSucceeded);
}

@end
