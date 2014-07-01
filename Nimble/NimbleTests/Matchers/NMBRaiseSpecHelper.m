//
//  NMBRaiseSpecHelper.m
//  Nimble
//
//  Created by Brian Ivan Gesiak on 7/1/14.
//
//

#import "NMBRaiseSpecHelper.h"

@implementation NMBRaiseSpecHelper

#pragma mark - Public Interface

+ (void)raise {
    [NSException raise:@"NMBRaiseSpecHelperException"
                format:@"This exception was thrown as part of a spec"];
}

@end
