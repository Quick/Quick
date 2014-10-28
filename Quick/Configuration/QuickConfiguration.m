#import "QuickConfiguration.h"
#import <Quick/Quick-Swift.h>
#import <objc/runtime.h>

typedef void (^QCKClassEnumerationBlock)(Class klass);

void qck_enumerateSubclasses(Class klass, QCKClassEnumerationBlock block) {
    Class *classes = NULL;
    int classesCount = objc_getClassList(NULL, 0);

    if (classesCount > 0) {
        classes = (Class *)calloc(sizeof(Class), classesCount);
        classesCount = objc_getClassList(classes, classesCount);

        Class subclass, superclass;
        for(int i = 0; i < classesCount; i++) {
            subclass = classes[i];
            superclass = class_getSuperclass(subclass);
            if (superclass == klass && block) {
                block(subclass);
            }
        }

        free(classes);
    }
}

@implementation QuickConfiguration

#pragma mark - NSObject Overrides

+ (void)initialize {
    if ([self class] == [QuickConfiguration class]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            qck_enumerateSubclasses([QuickConfiguration class], ^(__unsafe_unretained Class klass) {
                [[World sharedWorld] configure:^(Configuration *configuration) {
                    [klass configure:configuration];
                }];
            });
            [[World sharedWorld] finalizeConfiguration];
        });
    }
}

#pragma mark - Public Interface

+ (void)configure:(Configuration *)configuration { }

@end
