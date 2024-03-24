#import "QCKDSL.h"

#if __has_include("Quick-Swift.h")
#import "Quick-Swift.h"
#else
#import <Quick/Quick-Swift.h>
#endif

void qck_beforeSuite(QCKDSLEmptyBlock closure) {
    [[World sharedWorld] beforeSuite:closure];
}

void qck_afterSuite(QCKDSLEmptyBlock closure) {
    [[World sharedWorld] afterSuite:closure];
}

void qck_sharedExamples(NSString *name, QCKDSLSharedExampleBlock closure) {
    [[World sharedWorld] sharedExamples:name closure:closure];
}

void qck_describe(NSString *description, QCKDSLEmptyBlock closure) {
    [[World sharedWorld] describe:description flags:@{} closure:closure];
}

void qck_context(NSString *description, QCKDSLEmptyBlock closure) {
    qck_describe(description, closure);
}

void qck_beforeEach(QCKDSLEmptyBlock closure) {
    [[World sharedWorld] beforeEach:closure];
}

void qck_beforeEachWithMetadata(QCKDSLExampleMetadataBlock closure) {
    [[World sharedWorld] beforeEachWithMetadata:closure];
}

void qck_afterEach(QCKDSLEmptyBlock closure) {
    [[World sharedWorld] afterEach:closure];
}

void qck_afterEachWithMetadata(QCKDSLExampleMetadataBlock closure) {
    [[World sharedWorld] afterEachWithMetadata:closure];
}

void qck_justBeforeEach(QCKDSLEmptyBlock closure) {
    [[World sharedWorld] justBeforeEach:closure];
}

void qck_aroundEach(QCKDSLAroundExampleBlock closure) {
    [[World sharedWorld] aroundEach:closure];
}

void qck_aroundEachWithMetadata(QCKDSLAroundExampleMetadataBlock closure) {
    [[World sharedWorld] aroundEachWithMetadata:closure];
}

QCKItBlock qck_it_builder(NSString *file, NSUInteger line) {
    return ^(NSString *description, QCKDSLEmptyBlock closure) {
        [[World sharedWorld] itWithDescription:description
                                          file:file
                                          line:line
                                       closure:closure];
    };
}

QCKItBlock qck_xit_builder(NSString *file, NSUInteger line) {
    return ^(NSString *description, QCKDSLEmptyBlock closure) {
        [[World sharedWorld] xitWithDescription:description
                                           file:file
                                           line:line
                                        closure:closure];
    };
}

QCKItBlock qck_fit_builder(NSString *file, NSUInteger line) {
    return ^(NSString *description, QCKDSLEmptyBlock closure) {
        [[World sharedWorld] fitWithDescription:description
                                           file:file
                                           line:line
                                        closure:closure];
    };
}

QCKItBehavesLikeBlock qck_itBehavesLike_builder(NSString *file, NSUInteger line) {
    return ^(NSString *name, QCKDSLSharedExampleContext context) {
        [[World sharedWorld] itBehavesLikeSharedExampleNamed:name
                                        sharedExampleContext:context
                                                        file:file
                                                        line:line];
    };
}

QCKItBehavesLikeBlock qck_xitBehavesLike_builder(NSString *file, NSUInteger line) {
    return ^(NSString *name, QCKDSLSharedExampleContext context) {
        [[World sharedWorld] xitBehavesLikeSharedExampleNamed:name
                                         sharedExampleContext:context
                                                         file:file
                                                         line:line];
    };
}

QCKItBehavesLikeBlock qck_fitBehavesLike_builder(NSString *file, NSUInteger line) {
    return ^(NSString *name, QCKDSLSharedExampleContext context) {
        [[World sharedWorld] fitBehavesLikeSharedExampleNamed:name
                                         sharedExampleContext:context
                                                         file:file
                                                         line:line];
    };
}

QCKItBlock qck_pending_builder(NSString *file, NSUInteger line) {
    return ^(NSString *description, QCKDSLEmptyBlock closure) {
        [[World sharedWorld] pendingWithDescription:description file:file line:line closure:closure];
    };
}

void qck_fdescribe(NSString *description, QCKDSLEmptyBlock closure) {
    [[World sharedWorld] fdescribe:description closure:closure];
}

void qck_fcontext(NSString *description, QCKDSLEmptyBlock closure) {
    qck_fdescribe(description, closure);
}
