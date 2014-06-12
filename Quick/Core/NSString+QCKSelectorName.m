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
    
    static NSMutableCharacterSet *invalidCharacters = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        invalidCharacters = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
        
        [invalidCharacters formUnionWithCharacterSet:[NSCharacterSet illegalCharacterSet]];
        [invalidCharacters formUnionWithCharacterSet:[NSCharacterSet controlCharacterSet]];
        [invalidCharacters formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
        [invalidCharacters formUnionWithCharacterSet:[NSCharacterSet nonBaseCharacterSet]];
        [invalidCharacters formUnionWithCharacterSet:[NSCharacterSet symbolCharacterSet]];
    });
    
    NSArray *validComponents = [self componentsSeparatedByCharactersInSet:invalidCharacters];
    
    return [validComponents componentsJoinedByString:@"_"];
}

@end
