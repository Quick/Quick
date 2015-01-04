#import <XCTest/XCTest.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "QCKSpecRunner.h"

QuickSpecBegin(FunctionalTests_AfterSuite_AfterSuiteSpec)

QuickSpecEnd


QuickSpecBegin(FunctionalTests_AfterSuite_Spec)

QuickSpecEnd

@interface AfterSuiteTests : XCTestCase; @end

@implementation AfterSuiteTests

- (void)testAfterSuiteIsNotExecutedBeforeAnyExamples {

}

@end
