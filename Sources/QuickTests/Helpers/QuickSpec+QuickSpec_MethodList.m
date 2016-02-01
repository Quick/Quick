#import "QuickSpec+QuickSpec_MethodList.h"
#import <objc/runtime.h>


@implementation QuickSpec (QuickSpec_MethodList)

+ (NSSet<NSString*> *)allSelectors {
    id t = [[[self class] alloc] init];
    NSMutableSet<NSString*> *allSelectors = [NSMutableSet set];
    
    unsigned int methodCount = 0;
    Method * mlist = class_copyMethodList(object_getClass(t), &methodCount);

    for(int i = 0; i<methodCount; i++) {
        SEL selector = method_getName(mlist[i]);
        [allSelectors addObject:NSStringFromSelector(selector)];
    }
    
    return [allSelectors copy];
}

@end
