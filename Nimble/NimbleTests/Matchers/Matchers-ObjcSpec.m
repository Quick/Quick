//
//  Matchers-ObjcSpec.m
//  Nimble
//
//  Created by Dzianis Lebedzeu on 6/20/14.
//
//

#import <Nimble/Nimble.h>

@import XCTest;

@interface Test : XCTestCase

@end

@implementation Test

- (void)setUp {
    
}

- (void)testSum {
    [expect(@"1").to equal:@"1"];
}

@end