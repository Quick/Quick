//
//  QCKSpec.h
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

#import <XCTest/XCTest.h>

@class Example;

/**
 QuickSpec is a base class all specs written in Quick inherit from.
 They need to inherit from QuickSpec, a subclass of XCTestCase, in
 order to be discovered by the XCTest framework.

 XCTest automatically compiles a list of XCTestCase subclasses included
 in the test target. It iterates over each class in that list, and creates
 a new instance of that class for each test method. It then creates an
 "invocation" to execute that test method. The invocation is an instance of
 NSInvocation, which represents a single message send in Objective-C.
 The invocation is set on the XCTestCase instance, and the test is run.

 Most of the code in QuickSpec is dedicated to hooking into XCTest events.
 First, when the spec is first loaded and before it is sent any messages,
 the +[NSObject initialize] method is called. QuickSpec overrides this method
 to call +[QuickSpec exampleGroups]. This builds the example group stacks and
 registers them with Quick.World, a global register of examples.

 Then, XCTest queries QuickSpec for a list of test methods. Normally, XCTest
 automatically finds all methods whose selectors begin with the string "test".
 However, QuickSpec overrides this default behavior by implementing the
 +[XCTestCase testInvocations] method. This method iterates over each example
 registered in Quick.World, defines a new method for that example, and
 returns an invocation to call that method to XCTest. Those invocations are
 the tests that are run by XCTest. Their selector names are displayed in
 the Xcode test navigation bar.
 */
@interface QuickSpec : XCTestCase

/**
 Override this method in your spec to define a set of example groups
 and examples.

     override class func exampleGroups() {
         describe("winter") {
             it("is coming") {
                 // ...
             }
         }
     }

 See DSL.swift for more information on what syntax is available.
 */
- (void)exampleGroups;

/**
 This method is called when an unhandled exception is raised while an
 example is running. By default, the exception will be reported as an
 XCTest failure, and the example will be highlighted in Xcode.

 You can override this method in your spec if you wish to provide custom
 handling based on the specific exception.
 */
- (void)example:(Example *)example failedWithException:(NSException *)exception;

@end
