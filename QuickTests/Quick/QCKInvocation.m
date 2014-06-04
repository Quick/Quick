//
//  TestHarness.m
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

#import "QCKInvocation.h"
#import "QuickTests-Swift.h"

#pragma mark - Public Interface

extern NSString *qck_className(id object) {
    return NSStringFromClass([object class]);
}

extern NSInvocation *qck_invocationForExampleAtIndex(NSUInteger index) {
    SEL selector = @selector(runExampleAtIndex:);
    NSMethodSignature *signature = [[QuickSpec class] instanceMethodSignatureForSelector:selector];

    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.selector = selector;
    NSUInteger i = index;
    [invocation setArgument:&i atIndex:2];

    return invocation;
}
