@import XCTest;
#import <objc/runtime.h>

@interface XCTestObservationCenter (Redeclaration)
- (NSMutableSet *)observers;
@end

@implementation XCTestObservationCenter (QCKSuspendObservation)

static BOOL (^isFromApple)(id, BOOL *) = ^BOOL(id observer, BOOL *stop){
    return [[NSBundle bundleForClass:[observer class]].bundleIdentifier containsString:@"com.apple.dt.XCTest"];
};

- (void)qck_suspendObservationForBlock:(void (^)(void))block {
    NSSet *observersToSuspend = [[self observers] objectsPassingTest:isFromApple];
    [[self observers] minusSet:observersToSuspend];

    block();

    [[self observers] unionSet:observersToSuspend];
}

@end
