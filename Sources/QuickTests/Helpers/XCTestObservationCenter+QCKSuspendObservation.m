@import XCTest;
#import <objc/runtime.h>

@interface XCTestObservationCenter (Redeclaration)
- (NSMutableSet *)observers;
@end

@implementation XCTestObservationCenter (QCKSuspendObservation)

/// This allows us to only suspend observation for observers by provided by Apple
/// as a part of the XCTest framework. In particular it is important that we not
/// suspend the observer added by Nimble, otherwise it is unable to properly
/// report assertion failures.
static BOOL (^isFromApple)(id, BOOL *) = ^BOOL(id observer, BOOL *stop){
    return [[NSBundle bundleForClass:[observer class]].bundleIdentifier containsString:@"com.apple.dt.XCTest"];
};

- (void)qck_suspendObservationForBlock:(void (^)(void))block {
    NSSet *observersToSuspend = [[self observers] objectsPassingTest:isFromApple];
    [[self observers] minusSet:observersToSuspend];

    @try {
        block();
    }
    @finally {
        [[self observers] unionSet:observersToSuspend];
    }
}

@end
