//
//  NMBRaise.m
//  Nimble
//
//  Created by Brian Ivan Gesiak on 6/30/14.
//
//

#import "NMBRaise.h"

@implementation NMBRaise

+ (NSException *)raises:(void (^)(void))block {
    @try {
        block();
    }
    @catch (NSException *exception) {
        return exception;
    }

    return nil;
}

@end
