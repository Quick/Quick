//
//  NSString+QCKSelectorName.m
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/9/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

#import "NSString+QCKSelectorName.h"

@implementation NSString (QCKSelectorName)

- (NSString *)selectorName {
    NSString *validString = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_";
    NSCharacterSet *validCharacters = [NSCharacterSet characterSetWithCharactersInString:validString];
    NSCharacterSet *invalidCharacters = [validCharacters invertedSet];
    NSArray *validComponents = [self componentsSeparatedByCharactersInSet:invalidCharacters];
    return [validComponents componentsJoinedByString:@"_"];
}

@end
