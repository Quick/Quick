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

typedef NSDictionary *(^QCKDSLSharedExampleContext)(void);
typedef void (^QCKDSLSharedExampleBlock)(QCKDSLSharedExampleContext);
typedef void (^QCKDSLExampleBlock)(void);

extern void qck_beforeSuite(QCKDSLExampleBlock closure);
extern void qck_afterSuite(QCKDSLExampleBlock closure);
extern void qck_sharedExamples(NSString *name, QCKDSLSharedExampleBlock closure);
extern void qck_describe(NSString *description, QCKDSLExampleBlock closure);
extern void qck_context(NSString *description, QCKDSLExampleBlock closure);
extern void qck_beforeEach(QCKDSLExampleBlock closure);
extern void qck_afterEach(QCKDSLExampleBlock closure);
extern void qck_pending(NSString *description, QCKDSLExampleBlock closure);
extern void qck_xdescribe(NSString *description, QCKDSLExampleBlock closure);
extern void qck_xcontext(NSString *description, QCKDSLExampleBlock closure);
extern void qck_xit(NSString *description, QCKDSLExampleBlock closure);

#ifndef QUICK_DISABLE_SHORT_SYNTAX
static inline void beforeSuite(QCKDSLExampleBlock closure) {
    qck_beforeSuite(closure);
}

static inline void afterSuite(QCKDSLExampleBlock closure) {
    qck_afterSuite(closure);
}

static inline void sharedExamples(NSString *name, QCKDSLSharedExampleBlock closure) {
    qck_sharedExamples(name, closure);
}

static inline void describe(NSString *description, QCKDSLExampleBlock closure) {
    qck_describe(description, closure);
}

static inline void context(NSString *description, QCKDSLExampleBlock closure) {
    qck_context(description, closure);
}

static inline void beforeEach(QCKDSLExampleBlock closure) {
    qck_beforeEach(closure);
}

static inline void afterEach(QCKDSLExampleBlock closure) {
    qck_afterEach(closure);
}

static inline void pending(NSString *description, QCKDSLExampleBlock closure) {
    qck_pending(description, closure);
}

static inline void xdescribe(NSString *description, QCKDSLExampleBlock closure) {
    qck_xdescribe(description, closure);
}

static inline void xcontext(NSString *description, QCKDSLExampleBlock closure) {
    qck_xcontext(description, closure);
}

static inline void xit(NSString *description, QCKDSLExampleBlock closure) {
    qck_xit(description, closure);
}

#define it qck_it
#define itBehavesLike qck_itBehavesLike
#endif

#define qck_it qck_it_builder(@(__FILE__), __LINE__)
#define qck_itBehavesLike qck_itBehavesLike_builder(@(__FILE__), __LINE__)

typedef void (^QCKItBlock)(NSString *description, QCKDSLExampleBlock closure);
typedef void (^QCKItBehavesLikeBlock)(NSString *descritpion, QCKDSLSharedExampleContext context);

extern QCKItBlock qck_it_builder(NSString *file, NSUInteger line);
extern QCKItBehavesLikeBlock qck_itBehavesLike_builder(NSString *file, NSUInteger line);
