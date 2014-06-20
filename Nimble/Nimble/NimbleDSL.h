//
//  NimbleDSL.h
//  Nimble
//
//  Created by Dzianis Lebedzeu on 6/20/14.
//
//

#import <Foundation/Foundation.h>

#define expect(actual) [DSL expect:actual file:__FILE__ line:__LINE__]

@class Actual;
@interface NimbleDSL : NSObject

+ (Actual *)expect:(NSObject *)actual file:(NSString *)file line:(NSInteger)line;

@end
