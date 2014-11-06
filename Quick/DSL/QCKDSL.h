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

#ifndef QUICK_DISABLE_SHORT_SYNTAX
#define beforeSuite qck_beforeSuite
#define afterSuite qck_afterSuite
#define sharedExamples qck_sharedExamples
#define describe qck_describe
#define context qck_context
#define beforeEach qck_beforeEach
#define afterEach qck_afterEach
#define it qck_it
#define itBehavesLike qck_itBehavesLike
#define pending qck_pending
#define xdescribe qck_xdescribe
#define xcontext qck_xcontext
#define xit qck_xit
#endif

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

#define qck_it qck_it_builder(@(__FILE__), __LINE__)
#define qck_itBehavesLike qck_itBehavesLike_builder(@(__FILE__), __LINE__)

typedef void (^QCKItBlock)(NSString *description, QCKDSLExampleBlock closure);
typedef void (^QCKItBehavesLikeBlock)(NSString *descritpion, QCKDSLSharedExampleContext context);

extern QCKItBlock qck_it_builder(NSString *file, NSUInteger line);
extern QCKItBehavesLikeBlock qck_itBehavesLike_builder(NSString *file, NSUInteger line);
