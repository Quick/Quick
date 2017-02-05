#import "QuickSpecBase.h"

#pragma mark - _SelectorWrapper

@interface _SelectorWrapper ()
@property(nonatomic, assign) SEL selector;
@end

@implementation _SelectorWrapper

- (instancetype)initWithSelector:(SEL)selector {
    self = [super init];
    _selector = selector;
    return self;
}

@end


#pragma mark - _QuickSpecBase

@implementation _QuickSpecBase

- (instancetype)init {
    self = [super initWithInvocation: nil];
    return self;
}

/**
 Invocations for each test method in the test case. QuickSpec overrides this method to define a
 new method for each example defined in +[QuickSpec spec].

 @return An array of invocations that execute the newly defined example methods.
 */
+ (NSArray<NSInvocation *> *)testInvocations {
    NSArray<_SelectorWrapper *> *wrappers = [self _testMethodSelectors];
    NSMutableArray<NSInvocation *> *invocations = [NSMutableArray arrayWithCapacity:wrappers.count];

    for (_SelectorWrapper *wrapper in wrappers) {
        SEL selector = wrapper.selector;
        NSMethodSignature *signature = [self instanceMethodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.selector = selector;

        [invocations addObject:invocation];
    }

    return invocations;
}

+ (NSArray<_SelectorWrapper *> *)_testMethodSelectors {
    return @[];
}

@end
