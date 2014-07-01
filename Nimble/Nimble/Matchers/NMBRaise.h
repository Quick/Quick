//
//  NMBRaise.h
//  Nimble
//
//  Created by Brian Ivan Gesiak on 6/30/14.
//
//

#import <Foundation/Foundation.h>

@interface NMBRaise : NSObject

+ (void)raise;
+ (BOOL)raises:(void (^)(void))block;

@end
