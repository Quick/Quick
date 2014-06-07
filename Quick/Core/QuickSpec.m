//
//  QCKSpec.m
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

#import "QuickSpec.h"
#import <Quick/Quick-Swift.h>

static NSUInteger const QCKIndex = 2; // 0 is class, 1 is _cmd

@interface QuickSpec ()
@property (nonatomic, strong) Example *example;
@end

@implementation QuickSpec

#pragma mark - XCTestCase Overrides

+ (void)initialize {
    [World setCurrentExampleGroup:[World rootExampleGroupForSpecClass:[self class]]];
    [self exampleGroups];
}

+ (NSArray *)testInvocations {
    if (![self isConcreteSpec]) {
        return @[];
    }

    NSArray *examples = [World rootExampleGroupForSpecClass:[self class]].examples;
    NSMutableArray *invocations = [NSMutableArray arrayWithCapacity:[examples count]];
    for (NSUInteger index = 0; index < [examples count]; ++index) {
        [invocations addObject:[self invocationToRunExampleAtIndex:index]];
    }
    return invocations;
}

- (void)setInvocation:(NSInvocation *)invocation {
    self.example = [[self class] exampleForInvocation:invocation];
    [super setInvocation:invocation];
}

- (NSString *)name {
    return [NSString stringWithFormat:@"%@: %@",
            NSStringFromClass([self class]), self.example.name];
}

#pragma mark - Public Interface

+ (void)exampleGroups { }

+ (BOOL)isConcreteSpec {
    return NO;
}

#pragma mark - Internal Methods

+ (NSInvocation *)invocationToRunExampleAtIndex:(NSUInteger)index {
    SEL selector = @selector(runExampleAtIndex:);
    NSMethodSignature *signature = [self instanceMethodSignatureForSelector:selector];

    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.selector = selector;
    NSUInteger i = index;
    [invocation setArgument:&i atIndex:QCKIndex];

    return invocation;
}

+ (Example *)exampleForInvocation:(NSInvocation *)invocation {
    NSUInteger exampleIndex;
    [invocation getArgument:&exampleIndex atIndex:QCKIndex];
    return [World rootExampleGroupForSpecClass:[self class]].examples[exampleIndex];
}

- (void)runExampleAtIndex:(NSUInteger)index {
    ExampleGroup *group = [World rootExampleGroupForSpecClass:[self class]];
    Example *example = group.examples[index];
    [example run];
}

@end
