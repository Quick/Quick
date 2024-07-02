#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

NS_ASSUME_NONNULL_BEGIN

@interface _QuickSpecBase : XCTestCase
+ (NSArray<NSString *> *)_qck_testMethodSelectors;
- (instancetype)init NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END
