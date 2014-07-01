//
//  NMBRaiseSpecHelper.h
//  Nimble
//
//  Created by Brian Ivan Gesiak on 7/1/14.
//
//

#import <Foundation/Foundation.h>

@interface NMBRaiseSpecHelper : NSObject

+ (void)raise;
+ (void)raiseWithName:(NSString *)name;
+ (void)raiseWithName:(NSString *)name
               reason:(NSString *)reason;
+ (void)raiseWithName:(NSString *)name
               reason:(NSString *)reason
             userInfo:(NSDictionary *)userInfo;

@end
