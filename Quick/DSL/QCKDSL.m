#import "QCKDSL.h"
#import <Quick/Quick-Swift.h>

@implementation QCKDSL

+ (void)beforeSuite:(void (^)(void))closure {
    [[World sharedWorld] beforeSuite:closure];
}

+ (void)afterSuite:(void (^)(void))closure {
    [[World sharedWorld] afterSuite:closure];
}

+ (void)sharedExamples:(NSString *)name closure:(QCKDSLSharedExampleBlock)closure {
    [[World sharedWorld] sharedExamples:name closure:closure];
}

+ (void)describe:(NSString *)description closure:(void(^)(void))closure {
    [[World sharedWorld] describe:description closure:closure];
}

+ (void)context:(NSString *)description closure:(void(^)(void))closure {
    [self describe:description closure:closure];
}

+ (void)beforeEach:(void(^)(void))closure {
    [[World sharedWorld] beforeEach:closure];
}

+ (void)afterEach:(void(^)(void))closure {
    [[World sharedWorld] afterEach:closure];
}

+ (void)it:(NSString *)description file:(NSString *)file line:(NSUInteger)line closure:(void (^)(void))closure {
    [[World sharedWorld] it:description file:file line:line closure:closure];
}

+ (void)itBehavesLike:(NSString *)name context:(QCKDSLSharedExampleContext)context file:(NSString *)file line:(NSUInteger)line {
    [[World sharedWorld] itBehavesLike:name sharedExampleContext:context file:file line:line];
}

+ (void)pending:(NSString *)description closure:(void(^)(void))closure {
    [[World sharedWorld] pending:description closure:closure];
}

+ (void)xdescribe:(NSString *)description closure:(void(^)(void))closure {
    [self pending:description closure:closure];
}

+ (void)xcontext:(NSString *)description closure:(void(^)(void))closure {
    [self pending:description closure:closure];
}

+ (void)xit:(NSString *)description closure:(void(^)(void))closure {
    [self pending:description closure:closure];
}

@end
