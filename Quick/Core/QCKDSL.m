//
//  QCKDSL.m
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/11/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

#import "QCKDSL.h"
#import <Quick/Quick-Swift.h>

@implementation QCKDSL

+ (void)describe:(NSString *)description closure:(void(^)(void))closure {
    [DSL describe:description closure:closure];
}

+ (void)context:(NSString *)description closure:(void(^)(void))closure {
    [self describe:description closure:closure];
}

+ (void)beforeEach:(void(^)(void))closure {
    [DSL beforeEach:closure];
}

+ (void)afterEach:(void(^)(void))closure {
    [DSL afterEach:closure];
}

+ (void)it:(NSString *)description file:(NSString *)file line:(NSUInteger)line closure:(void (^)(void))closure {
    [DSL it:description file:file line:line closure:closure];
}

+ (void)pending:(NSString *)description closure:(void(^)(void))closure {
    [DSL pending:description closure:closure];
}

@end
