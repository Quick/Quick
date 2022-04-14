#import <Foundation/Foundation.h>

@class ExampleMetadata;

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

typedef NSDictionary *(^QCKDSLSharedExampleContext)(void);
typedef void (^QCKDSLSharedExampleBlock)(QCKDSLSharedExampleContext);
typedef void (^QCKDSLEmptyBlock)(void);
typedef void (^QCKDSLExampleMetadataBlock)(ExampleMetadata *exampleMetadata);
typedef void (^QCKDSLAroundExampleBlock)(QCKDSLEmptyBlock runExample);
typedef void (^QCKDSLAroundExampleMetadataBlock)(ExampleMetadata *exampleMetadata, QCKDSLEmptyBlock runExample);

#define QUICK_EXPORT FOUNDATION_EXPORT

QUICK_EXPORT void qck_beforeSuite(QCKDSLEmptyBlock closure);
QUICK_EXPORT void qck_afterSuite(QCKDSLEmptyBlock closure);
QUICK_EXPORT void qck_sharedExamples(NSString *name, QCKDSLSharedExampleBlock closure);
QUICK_EXPORT void qck_describe(NSString *description, QCKDSLEmptyBlock closure);
QUICK_EXPORT void qck_context(NSString *description, QCKDSLEmptyBlock closure);
QUICK_EXPORT void qck_beforeEach(QCKDSLEmptyBlock closure);
QUICK_EXPORT void qck_beforeEachWithMetadata(QCKDSLExampleMetadataBlock closure);
QUICK_EXPORT void qck_afterEach(QCKDSLEmptyBlock closure);
QUICK_EXPORT void qck_afterEachWithMetadata(QCKDSLExampleMetadataBlock closure);
QUICK_EXPORT void qck_aroundEach(QCKDSLAroundExampleBlock closure);
QUICK_EXPORT void qck_aroundEachWithMetadata(QCKDSLAroundExampleMetadataBlock closure);
QUICK_EXPORT void qck_pending(NSString *description, QCKDSLEmptyBlock closure);
QUICK_EXPORT void qck_xdescribe(NSString *description, QCKDSLEmptyBlock closure);
QUICK_EXPORT void qck_xcontext(NSString *description, QCKDSLEmptyBlock closure);
QUICK_EXPORT void qck_fdescribe(NSString *description, QCKDSLEmptyBlock closure);
QUICK_EXPORT void qck_fcontext(NSString *description, QCKDSLEmptyBlock closure);

#ifndef QUICK_DISABLE_SHORT_SYNTAX
/**
    Defines a closure to be run prior to any examples in the test suite.
    You may define an unlimited number of these closures, but there is no
    guarantee as to the order in which they're run.
 
    If the test suite crashes before the first example is run, this closure
    will not be executed.
 
    @param closure The closure to be run prior to any examples in the test suite.
 */
static inline void beforeSuite(QCKDSLEmptyBlock closure) {
    qck_beforeSuite(closure);
}


/**
    Defines a closure to be run after all of the examples in the test suite.
    You may define an unlimited number of these closures, but there is no
    guarantee as to the order in which they're run.
     
    If the test suite crashes before all examples are run, this closure
    will not be executed.
 
    @param closure The closure to be run after all of the examples in the test suite.
 */
static inline void afterSuite(QCKDSLEmptyBlock closure) {
    qck_afterSuite(closure);
}

/**
    Defines a group of shared examples. These examples can be re-used in several locations
    by using the `itBehavesLike` function.
 
    @param name The name of the shared example group. This must be unique across all shared example
                groups defined in a test suite.
    @param closure A closure containing the examples. This behaves just like an example group defined
                   using `describe` or `context`--the closure may contain any number of `beforeEach`
                   and `afterEach` closures, as well as any number of examples (defined using `it`).
 */
static inline void sharedExamples(NSString *name, QCKDSLSharedExampleBlock closure) {
    qck_sharedExamples(name, closure);
}

/**
    Defines an example group. Example groups are logical groupings of examples.
    Example groups can share setup and teardown code.
 
    @param description An arbitrary string describing the example group.
    @param closure A closure that can contain other examples.
 */
static inline void describe(NSString *description, QCKDSLEmptyBlock closure) {
    qck_describe(description, closure);
}

/**
    Defines an example group. Equivalent to `describe`.
 */
static inline void context(NSString *description, QCKDSLEmptyBlock closure) {
    qck_context(description, closure);
}

/**
    Defines a closure to be run prior to each example in the current example
    group. This closure is not run for pending or otherwise disabled examples.
    An example group may contain an unlimited number of beforeEach. They'll be
    run in the order they're defined, but you shouldn't rely on that behavior.
 
    @param closure The closure to be run prior to each example.
 */
static inline void beforeEach(QCKDSLEmptyBlock closure) {
    qck_beforeEach(closure);
}

/**
    Identical to QCKDSL.beforeEach, except the closure is provided with
    metadata on the example that the closure is being run prior to.
 */
static inline void beforeEachWithMetadata(QCKDSLExampleMetadataBlock closure) {
    qck_beforeEachWithMetadata(closure);
}

/**
    Defines a closure to be run after each example in the current example
    group. This closure is not run for pending or otherwise disabled examples.
    An example group may contain an unlimited number of afterEach. They'll be
    run in the order they're defined, but you shouldn't rely on that behavior.
 
    @param closure The closure to be run after each example.
 */
static inline void afterEach(QCKDSLEmptyBlock closure) {
    qck_afterEach(closure);
}

/**
    Identical to QCKDSL.afterEach, except the closure is provided with
    metadata on the example that the closure is being run after.
 */
static inline void afterEachWithMetadata(QCKDSLExampleMetadataBlock closure) {
    qck_afterEachWithMetadata(closure);
}

/**
    Defines a closure to that wraps each example in the current example
    group. This closure is not run for pending or otherwise disabled examples.

    The closure you pass to aroundEach receives a callback as its argument, which
    it MUST call exactly one for the example to run properly:

        aroundEach(^(QCKDSLEmptyBlock runExample) {
            [self doSomeSetup];
            runExample();
            [self doSomeCleanup];
        });

    This callback is particularly useful for test decartions that can’t split
    into a separate beforeEach and afterEach. For example, running each example
    in its own autorelease pool requires aroundEach:

        aroundEach(^(QCKDSLEmptyBlock runExample) {
            @autoreleasepool {
                runExample();
            }
            [self checkObjectsNoLongerRetained];
        });

    You can also use aroundEach to guarantee proper nesting of setup and cleanup
    operations in situations where their relative order matters.

    An example group may contain an unlimited number of aroundEach callbacks.
    They will nest inside each other, with the first declared in the group
    nested at the outermost level.

    - parameter closure: The closure that wraps around each example.
*/
static inline void aroundEach(QCKDSLAroundExampleBlock closure) {
    qck_aroundEach(closure);
}

/**
    Identical to Quick.DSL.aroundEach, except the closure receives metadata
    about the example that the closure wraps.
 */
static inline void aroundEachWithMetadata(QCKDSLAroundExampleMetadataBlock closure) {
    qck_aroundEachWithMetadata(closure);
}

/**
    Defines an example or example group that should not be executed. Use `pending` to temporarily disable
    examples or groups that should not be run yet.
 
    @param description An arbitrary string describing the example or example group.
    @param closure A closure that will not be evaluated.
 */
static inline void pending(NSString *description, QCKDSLEmptyBlock closure) {
    qck_pending(description, closure);
}

/**
    Use this to quickly mark a `describe` block as pending.
    This disables all examples within the block.
 */
static inline void xdescribe(NSString *description, QCKDSLEmptyBlock closure) {
    qck_xdescribe(description, closure);
}

/**
    Use this to quickly mark a `context` block as pending.
    This disables all examples within the block.
 */
static inline void xcontext(NSString *description, QCKDSLEmptyBlock closure) {
    qck_xcontext(description, closure);
}

/**
    Use this to quickly focus a `describe` block, focusing the examples in the block.
    If any examples in the test suite are focused, only those examples are executed.
    This trumps any explicitly focused or unfocused examples within the block--they are all treated as focused.
 */
static inline void fdescribe(NSString *description, QCKDSLEmptyBlock closure) {
    qck_fdescribe(description, closure);
}

/**
    Use this to quickly focus a `context` block. Equivalent to `fdescribe`.
 */
static inline void fcontext(NSString *description, QCKDSLEmptyBlock closure) {
    qck_fcontext(description, closure);
}

#define it qck_it
#define xit qck_xit
#define fit qck_fit
#define itBehavesLike qck_itBehavesLike
#define xitBehavesLike qck_xitBehavesLike
#define fitBehavesLike qck_fitBehavesLike
#endif

#define qck_it qck_it_builder(@(__FILE__), __LINE__)
#define qck_xit qck_xit_builder(@(__FILE__), __LINE__)
#define qck_fit qck_fit_builder(@(__FILE__), __LINE__)
#define qck_itBehavesLike qck_itBehavesLike_builder(@(__FILE__), __LINE__)
#define qck_xitBehavesLike qck_xitBehavesLike_builder(@(__FILE__), __LINE__)
#define qck_fitBehavesLike qck_fitBehavesLike_builder(@(__FILE__), __LINE__)

typedef void (^QCKItBlock)(NSString *description, QCKDSLEmptyBlock closure);
typedef void (^QCKItBehavesLikeBlock)(NSString *description, QCKDSLSharedExampleContext context);

QUICK_EXPORT QCKItBlock qck_it_builder(NSString *file, NSUInteger line);
QUICK_EXPORT QCKItBlock qck_xit_builder(NSString *file, NSUInteger line);
QUICK_EXPORT QCKItBlock qck_fit_builder(NSString *file, NSUInteger line);
QUICK_EXPORT QCKItBehavesLikeBlock qck_itBehavesLike_builder(NSString *file, NSUInteger line);
QUICK_EXPORT QCKItBehavesLikeBlock qck_xitBehavesLike_builder(NSString *file, NSUInteger line);
QUICK_EXPORT QCKItBehavesLikeBlock qck_fitBehavesLike_builder(NSString *file, NSUInteger line);
