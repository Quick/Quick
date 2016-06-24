@import XCTest;
#import <objc/runtime.h>

static void *kObserversKey = &kObserversKey;

@interface XCTestObservationCenter (Redeclaration)
- (NSMutableArray *)observers;
@end

@implementation XCTestObservationCenter (QCKSuspendObservation)

/// This allows us to only suspend observation for observers by provided by Apple
/// as a part of the XCTest framework. In particular it is important that we not
/// suspend the observer added by Nimble, otherwise it is unable to properly
/// report assertion failures.
static BOOL (^isFromApple)(id, NSUInteger, BOOL *) = ^BOOL(id observer, NSUInteger idx, BOOL *stop) {
    return [[NSBundle bundleForClass:[observer class]].bundleIdentifier containsString:@"com.apple.dt.XCTest"];
};

- (void)qck_suspendObservationForBlock:(void (^)(void))block {
    NSIndexSet *observersToSuspendIndexes = [[self observers] indexesOfObjectsPassingTest:isFromApple];
    NSArray *observersToSuspend = [[self observers] objectsAtIndexes:observersToSuspendIndexes];

    [[self observers] removeObjectsInArray:observersToSuspend];

    @try {
        block();
    }
    @finally {
        [[self observers] addObjectsFromArray:observersToSuspend];
    }
}

@end
