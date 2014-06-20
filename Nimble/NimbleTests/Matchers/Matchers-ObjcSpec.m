//
//  Matchers-ObjcSpec.m
//  Nimble
//
//  Created by Dzianis Lebedzeu on 6/20/14.
//
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

QuickSpecBegin(FunctionalTestsObjC)

qck_it(@"contains an it block", ^{
    //expect(@0);
    
    [DSL expect:@"" file:@"" line:11];
    //XCTAssertTrue(true, @"expected to be true");
});

QuickSpecEnd

