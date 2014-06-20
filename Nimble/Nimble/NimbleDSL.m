//
//  NimbleDSL.m
//  Nimble
//
//  Created by Dzianis Lebedzeu on 6/20/14.
//
//

#import "NimbleDSL.h"
#import <Nimble/Nimble-Swift.h>

@implementation NimbleDSL

+ (Actual *)expect:(NSObject *)actual file:(NSString *)file line:(NSInteger)line
{
    return [DSL expect:actual file:file line:line];
}

@end
