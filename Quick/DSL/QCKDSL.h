#import <Foundation/Foundation.h>

/**
 Provides a hook for Quick to be configured before any examples are run.
 Within this scope, override the +[QuickConfiguration configure:] method
 to set properties on a configuration object to customize Quick behavior.
 For details, see the documentation for Configuraiton.swift.

 @param name The name of the configuration class. Like any Objective-C
             class name, this must be unique to the current runtime
             environment.
 */
#define QuickConfigurationBegin(name) \
    @interface name : QuickConfiguration; @end \
    @implementation name \


/**
 Marks the end of a Quick configuration.
 Make sure you put this after `QuickConfigurationBegin`.
 */
#define QuickConfigurationEnd \
    @end \


/**
 Defines a new QuickSpec. Define examples and example groups within the space
 between this and `QuickSpecEnd`.

 @param name The name of the spec class. Like any Objective-C class name, this
             must be unique to the current runtime environment.
 */
#define QuickSpecBegin(name) \
    @interface name : QuickSpec; @end \
    @implementation name \
    - (void)spec { \


/**
 Marks the end of a QuickSpec. Make sure you put this after `QuickSpecBegin`.
 */
#define QuickSpecEnd \
    } \
    @end \


#define qck_beforeSuite(...) [QCKDSL beforeSuite:__VA_ARGS__]
#define qck_afterSuite(...) [QCKDSL afterSuite:__VA_ARGS__]
#define qck_sharedExamples(name, ...) [QCKDSL sharedExamples:name closure:__VA_ARGS__]
#define qck_describe(description, ...) [QCKDSL describe:description closure:__VA_ARGS__]
#define qck_context(description, ...) [QCKDSL context:description closure:__VA_ARGS__]
#define qck_beforeEach(...) [QCKDSL beforeEach:__VA_ARGS__]
#define qck_afterEach(...) [QCKDSL afterEach:__VA_ARGS__]
#define qck_it(description, ...) [QCKDSL it:description file:@(__FILE__) line:__LINE__ closure:__VA_ARGS__]
#define qck_itBehavesLike(name, ...) [QCKDSL itBehavesLike:name context:__VA_ARGS__ file:@(__FILE__) line:__LINE__]
#define qck_pending(description, ...) [QCKDSL pending:description closure:__VA_ARGS__]
#define qck_xdescribe(description, ...) [QCKDSL xdescribe:description closure:__VA_ARGS__]
#define qck_xcontext(description, ...) [QCKDSL xcontext:description closure:__VA_ARGS__]
#define qck_xit(description, ...) [QCKDSL xit:description closure:__VA_ARGS__]

#ifndef QUICK_DISABLE_SHORT_SYNTAX
#define beforeSuite(...) qck_beforeSuite(__VA_ARGS__)
#define afterSuite(...) qck_afterSuite(__VA_ARGS__)
#define sharedExamples(name, ...) qck_sharedExamples(name, __VA_ARGS__)
#define describe(description, ...) qck_describe(description, __VA_ARGS__)
#define context(description, ...) qck_context(description, __VA_ARGS__)
#define beforeEach(...) qck_beforeEach(__VA_ARGS__)
#define afterEach(...) qck_afterEach(__VA_ARGS__)
#define it(description, ...) qck_it(description, __VA_ARGS__)
#define itBehavesLike(name, ...) qck_itBehavesLike(name, __VA_ARGS__)
#define pending(description, ...) qck_pending(description, __VA_ARGS__)
#define xdescribe(description, ...) qck_xdescribe(description, __VA_ARGS__)
#define xcontext(description, ...) qck_xcontext(description, __VA_ARGS__)
#define xit(description, ...) qck_xit(description, __VA_ARGS__)
#endif

typedef NSDictionary *(^QCKDSLSharedExampleContext)(void);
typedef void (^QCKDSLSharedExampleBlock)(QCKDSLSharedExampleContext);

@interface QCKDSL : NSObject

+ (void)beforeSuite:(void(^)(void))closure;
+ (void)afterSuite:(void(^)(void))closure;
+ (void)sharedExamples:(NSString *)name closure:(QCKDSLSharedExampleBlock)closure;
+ (void)describe:(NSString *)description closure:(void(^)(void))closure;
+ (void)context:(NSString *)description closure:(void(^)(void))closure;
+ (void)beforeEach:(void(^)(void))closure;
+ (void)afterEach:(void(^)(void))closure;
+ (void)it:(NSString *)description file:(NSString *)file line:(NSUInteger)line closure:(void(^)(void))closure;
+ (void)itBehavesLike:(NSString *)name context:(QCKDSLSharedExampleContext)context file:(NSString *)file line:(NSUInteger)line;
+ (void)pending:(NSString *)description closure:(void(^)(void)) __unused closure;
+ (void)xdescribe:(NSString *)description closure:(void(^)(void)) __unused closure;
+ (void)xcontext:(NSString *)description closure:(void(^)(void)) __unused closure;
+ (void)xit:(NSString *)description closure:(void(^)(void)) __unused closure;

@end
