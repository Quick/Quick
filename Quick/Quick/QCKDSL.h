//
//  QCKDSL.h
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/11/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

#import <Foundation/Foundation.h>

#define QuickSpecBegin(name) \
    @interface name : QuickSpec; @end \
    @implementation name \
    - (void)spec { \


#define QuickSpecEnd \
    } \
    @end \


#define qck_beforeSuite(block) [QCKDSL beforeSuite:block]
#define qck_afterSuite(block) [QCKDSL afterSuite:block]
#define qck_describe(description, block) [QCKDSL describe:description closure:block]
#define qck_context(description, block) [QCKDSL context:description closure:block]
#define qck_beforeEach(block) [QCKDSL beforeEach:block]
#define qck_afterEach(block) [QCKDSL afterEach:block]
#define qck_it(description, block) [QCKDSL it:description file:@(__FILE__) line:__LINE__ closure:block]
#define qck_pending(description, block) [QCKDSL pending:description closure:block]

@interface QCKDSL : NSObject

+ (void)beforeSuite:(void(^)(void))closure;
+ (void)afterSuite:(void(^)(void))closure;
+ (void)describe:(NSString *)description closure:(void(^)(void))closure;
+ (void)context:(NSString *)description closure:(void(^)(void))closure;
+ (void)beforeEach:(void(^)(void))closure;
+ (void)afterEach:(void(^)(void))closure;

+ (void)it:(NSString *)description file:(NSString *)file line:(NSUInteger)line closure:(void(^)(void))closure;
+ (void)pending:(NSString *)description closure:(void(^)(void)) __unused closure;

@end
