//
//  NimbleDSL.h
//  Nimble
//
//  Created by Dzianis Lebedzeu on 6/20/14.
//
//

#import <Foundation/Foundation.h>

#define expect(actual) [NimbleDSL expect:actual file:@(__FILE__) line:__LINE__]

@class Actual;
@class Prediction;

@interface NimbleDSL : NSObject

+ (Actual *)expect:(NSObject *)actual file:(NSString *)file line:(NSInteger)line;

@end
