#import "QCKDSL.h"
#import <Quick/Quick-Swift.h>

void qck_beforeSuite(QCKDSLExampleBlock closure) {
    [[World sharedWorld] beforeSuite:closure];
}

void qck_afterSuite(QCKDSLExampleBlock closure) {
    [[World sharedWorld] afterSuite:closure];
}

void qck_sharedExamples(NSString *name, QCKDSLSharedExampleBlock closure) {
    [[World sharedWorld] sharedExamples:name closure:closure];
}

void qck_describe(NSString *description, QCKDSLExampleBlock closure) {
    [[World sharedWorld] describe:description closure:closure];
}

void qck_context(NSString *description, QCKDSLExampleBlock closure) {
	qck_describe(description, closure);
}

void qck_beforeEach(QCKDSLExampleBlock closure) {
    [[World sharedWorld] beforeEach:closure];
}

void qck_afterEach(QCKDSLExampleBlock closure) {
    [[World sharedWorld] afterEach:closure];
}

QCKItBlock qck_it_builder(NSString *file, NSUInteger line) {
    return ^(NSString *description, QCKDSLExampleBlock closure) {
        [[World sharedWorld] it:description file:file line:line closure:closure];
    };
}

QCKItBehavesLikeBlock qck_itBehavesLike_builder(NSString *file, NSUInteger line) {
    return ^(NSString *description, QCKDSLSharedExampleContext context) {
        [[World sharedWorld] itBehavesLike:name sharedExampleContext:context file:file line:line];
    };
}

void qck_pending(NSString *description, QCKDSLExampleBlock closure) {
    [[World sharedWorld] pending:description closure:closure];
}

void qck_xdescribe(NSString *description, QCKDSLExampleBlock closure) {
	qck_pending(description, closure);
}

void qck_xcontext(NSString *description, QCKDSLExampleBlock closure) {
	qck_pending(description, closure);
}

void qck_xit(NSString *description, QCKDSLExampleBlock closure) {
	qck_pending(description, closure);
}
