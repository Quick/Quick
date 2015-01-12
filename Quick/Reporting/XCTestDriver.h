#import <Foundation/Foundation.h>
#import "XCTestManager_IDEInterface.h"

@interface XCTestDriver : NSObject

@property(readonly) id <XCTestManager_IDEInterface> IDEProxy;

+ (id)sharedTestDriver;

@end
