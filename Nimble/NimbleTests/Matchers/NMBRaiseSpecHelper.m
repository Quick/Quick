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
    [self raiseWithName:NSInternalInconsistencyException reason:nil userInfo:nil];
}

+ (void)raiseWithName:(NSString *)name {
    [self raiseWithName:name reason:nil userInfo:nil];
}

+ (void)raiseWithName:(NSString *)name reason:(NSString *)reason {
    [self raiseWithName:name reason:reason userInfo:nil];
}

+ (void)raiseWithName:(NSString *)name
               reason:(NSString *)reason
             userInfo:(NSDictionary *)userInfo {
    NSException *exception = [NSException exceptionWithName:name
                                                     reason:reason
                                                   userInfo:userInfo];
    [exception raise];
}

@end
