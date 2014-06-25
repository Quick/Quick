//
//  NMBDSL.h
//  Nimble
//
//  Created by Brian Ivan Gesiak on 6/24/14.
//

#import <Foundation/Foundation.h>

@class Actual;
@class ActualClosure;

#define nmb_expect(actual) [NMBDSL expect:actual file:@(__FILE__) line:__LINE__]
#define nmb_expectBlock(block) [NMBDSL expectBlock:block file:@(__FILE__) line:__LINE__]

@interface NMBDSL : NSObject

+ (Actual *)expect:(NSObject *)actual file:(NSString *)file line:(NSUInteger)line;
+ (ActualClosure *)expectBlock:(NSObject *(^)(void))block file:(NSString *)file line:(NSUInteger)line;

@end
