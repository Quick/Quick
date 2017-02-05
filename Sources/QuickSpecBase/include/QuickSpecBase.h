@import Foundation;
@import XCTest;

@interface _SelectorWrapper : NSObject
- (instancetype)initWithSelector:(SEL)selector;
@end

@interface _QuickSpecBase : XCTestCase
+ (NSArray<_SelectorWrapper *> *)_testMethodSelectors;
- (instancetype)init NS_DESIGNATED_INITIALIZER;
@end
