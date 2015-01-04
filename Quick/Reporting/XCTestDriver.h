//
//  XCTestDriver.h
//  Quick
//
//  Created by Paul Young on 1/3/15.
//  Copyright (c) 2015 Brian Ivan Gesiak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCTestManager_IDEInterface.h"

@interface XCTestDriver : NSObject

@property(readonly) id <XCTestManager_IDEInterface> IDEProxy;

+ (id)sharedTestDriver;

@end
