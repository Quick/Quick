//
//  NMBRaise.m
//  Nimble
//
//  Created by Brian Ivan Gesiak on 6/30/14.
//
//

#import "NMBRaise.h"

@implementation NMBRaise

+ (void)raise {
    [NSException raise:NSInternalInconsistencyException format:@""];
}

+ (BOOL)raises:(void (^)(void))block {
    @try {
        block();
    }
    @catch (NSException *exception) {
        return YES;
    }

    return NO;
}

@end
