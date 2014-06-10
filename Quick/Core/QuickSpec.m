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

/**
 The runtime sends initialize to each class in a program just before the class, or any class
 that inherits from it, is sent its first message from within the program. Hook into this
 event to compile the example groups for this spec subclass.
 */
+ (void)initialize {
    [World setCurrentExampleGroup:[World rootExampleGroupForSpecClass:[self class]]];
    [self exampleGroups];
}

/**
 Invocations for each test method in the test case. Override this method to define a new
 method for each example defined in +[QuickSpec exampleGroups].

 @return An array of invocations that execute the newly defined example methods.
 */
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

/**
 XCTest sets the invocation for the current test case instance using this setter.
 Hook into this event to give the test case a reference to the current example.
 It will need this reference to correctly report its name to XCTest.
 */
- (void)setInvocation:(NSInvocation *)invocation {
    self.example = objc_getAssociatedObject(invocation, QCKExampleKey);
    [super setInvocation:invocation];
}

/**
 The test's name. This is to be overridden by subclasses. By default, this uses the
 invocation's selector's name (i.e.: "-[WinterTests testWinterIsComing]").
 This method provides the name of the test class, along with a string made up
 of the example group and example descriptions.

 This string is displayed in the log navigator as the test is being run.
 */
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
