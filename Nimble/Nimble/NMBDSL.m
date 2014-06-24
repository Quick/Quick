//
//  NMBDSL.m
//  Nimble
//
//  Created by Brian Ivan Gesiak on 6/24/14.
//

#import "NMBDSL.h"
#import <Nimble/Nimble-Swift.h>

@implementation NMBDSL

#pragma mark - Public Interface

+ (Actual *)expect:(NSObject *)actual file:(NSString *)file line:(NSUInteger)line {
    return [DSL expect:actual file:file line:line];
}

+ (ActualClosure *)expectBlock:(NSObject *(^)(void))block file:(NSString *)file line:(NSUInteger)line {
    return [DSL expectBlock:block file:file line:line];
}

@end
