//
//  QCKSpec.m
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

#import "QuickSpec.h"
#import "NSString+QCKSelectorName.h"
#import <Quick/Quick-Swift.h>
#import <objc/runtime.h>

const void * const QCKExampleKey = &QCKExampleKey;

@interface QuickSpec ()
@property (nonatomic, strong) Example *example;
@end

@implementation QuickSpec

#pragma mark - XCTestCase Overrides

+ (void)initialize {
    [World setCurrentExampleGroup:[World rootExampleGroupForSpecClass:[self class]]];
    [World runBeforeSuite];
    [self exampleGroups];
    [World runAfterSuite];
}

+ (NSArray *)testInvocations {
    NSArray *examples = [World rootExampleGroupForSpecClass:[self class]].examples;
    NSMutableArray *invocations = [NSMutableArray arrayWithCapacity:[examples count]];

    for (Example *example in examples) {
        SEL selector = [self addInstanceMethodForExample:example];
        NSInvocation *invocation = [self invocationForInstanceMethodWithSelector:selector
                                                                         example:example];
        [invocations addObject:invocation];
    }

    return invocations;
}

- (void)setInvocation:(NSInvocation *)invocation {
    self.example = objc_getAssociatedObject(invocation, QCKExampleKey);
    [super setInvocation:invocation];
}

- (NSString *)name {
    return [NSString stringWithFormat:@"%@: %@",
            NSStringFromClass([self class]), self.example.name];
}

#pragma mark - Public Interface

+ (void)exampleGroups { }

#pragma mark - Internal Methods

+ (SEL)addInstanceMethodForExample:(Example *)example {
    IMP implementation = imp_implementationWithBlock(^(id self){
        [example run];
    });
    const char *types = [[NSString stringWithFormat:@"%s%s%s", @encode(id), @encode(id), @encode(SEL)] UTF8String];
    SEL selector = NSSelectorFromString(example.name.selectorName);
    class_addMethod(self, selector, implementation, types);

    return selector;
}

+ (NSInvocation *)invocationForInstanceMethodWithSelector:(SEL)selector
                                                  example:(Example *)example {
    NSMethodSignature *signature = [self instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.selector = selector;
    objc_setAssociatedObject(invocation,
                             QCKExampleKey,
                             example,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return invocation;
}

@end
