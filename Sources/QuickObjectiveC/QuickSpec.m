#import "QuickSpec.h"
#import "QuickConfiguration.h"

#if __has_include("Quick-Swift.h")
#import "Quick-Swift.h"
#else
#import <Quick/Quick-Swift.h>
#endif

static QuickSpec *currentSpec = nil;

@interface QuickSpec ()
@property (nonatomic, strong) Example *example;
@end

@implementation QuickSpec

#pragma mark - XCTestCase Overrides

/**
 Invocations for each test method in the test case. QuickSpec overrides this method to define a
 new method for each example defined in +[QuickSpec spec].

 @return An array of invocations that execute the newly defined example methods.
 */
+ (NSArray *)testInvocations {
    // Xcode 13.3 hack, see this issue for more info: https://github.com/Quick/Quick/issues/1123
    // In case of fix in later versions next line can be removed
    [[QuickTestObservation sharedInstance] buildAllExamplesIfNeeded];

    NSArray *examples = [[World sharedWorld] examplesForSpecClass:[self class]];
    NSMutableArray *invocations = [NSMutableArray arrayWithCapacity:[examples count]];
    
    NSMutableSet<NSString*> *selectorNames = [NSMutableSet set];
    
    for (Example *example in examples) {
        SEL selector = [self addInstanceMethodForExample:example classSelectorNames:selectorNames];

        NSMethodSignature *signature = [self instanceMethodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.selector = selector;

        [invocations addObject:invocation];
    }

    return invocations;
}

#pragma mark - Public Interface

- (void)spec { }

+ (QuickSpec*) current {
    return currentSpec;
}

#pragma mark - Internal Methods

/**
 Runs the `spec` method and builds the examples for this class.

 It's safe to call this method multiple times. If the examples for the class have been built, invocation
 of this method has no effect.
 */
+ (void)buildExamplesIfNeeded {
    [QuickConfiguration class];
    World *world = [World sharedWorld];

    if ([world isRootExampleGroupInitializedForSpecClass:[self class]]) {
        // The examples for this subclass have been already built. Skipping.
        return;
    }

    ExampleGroup *rootExampleGroup = [world rootExampleGroupForSpecClass:[self class]];
    [world performWithCurrentExampleGroup:rootExampleGroup closure:^{
        QuickSpec *spec = [self new];

        @try {
            [spec spec];
        }
        @catch (NSException *exception) {
            [NSException raise:NSInternalInconsistencyException
                        format:@"An exception occurred when building Quick's example groups.\n"
             @"Some possible reasons this might happen include:\n\n"
             @"- An 'expect(...).to' expectation was evaluated outside of "
             @"an 'it', 'context', or 'describe' block\n"
             @"- 'sharedExamples' was called twice with the same name\n"
             @"- 'itBehavesLike' was called with a name that is not registered as a shared example\n\n"
             @"Here's the original exception: '%@', reason: '%@', userInfo: '%@'",
             exception.name, exception.reason, exception.userInfo];
        }
    }];
}

/**
 QuickSpec uses this method to dynamically define a new instance method for the
 given example. The instance method runs the example, catching any exceptions.
 The exceptions are then reported as test failures.

 In order to report the correct file and line number, examples must raise exceptions
 containing following keys in their userInfo:

 - "SenTestFilenameKey": A String representing the file name
 - "SenTestLineNumberKey": An Int representing the line number

 These keys used to be used by SenTestingKit, and are still used by some testing tools
 in the wild. See: https://github.com/Quick/Quick/pull/41

 @return The selector of the newly defined instance method.
 */
+ (SEL)addInstanceMethodForExample:(Example *)example classSelectorNames:(NSMutableSet<NSString*> *)selectorNames {
    IMP implementation = imp_implementationWithBlock(^(QuickSpec *self){
        self.example = example;
        currentSpec = self;
        [example run];
    });

    const char *types = [[NSString stringWithFormat:@"%s%s%s", @encode(void), @encode(id), @encode(SEL)] UTF8String];

    NSString *originalName = [QCKObjCStringUtils c99ExtendedIdentifierFrom:example.name];
    NSString *selectorName = originalName;
    NSUInteger i = 2;
    
    while ([selectorNames containsObject:selectorName]) {
        selectorName = [NSString stringWithFormat:@"%@_%tu", originalName, i++];
    }
    
    [selectorNames addObject:selectorName];
    
    SEL selector = NSSelectorFromString(selectorName);
    class_addMethod(self, selector, implementation, types);

    return selector;
}

/**
 This method is used to record failures, whether they represent example
 expectations that were not met, or exceptions raised during test setup
 and teardown. By default, the failure will be reported as an
 XCTest failure, and the example will be highlighted in Xcode.
 */
- (void)recordIssue:(XCTIssue *)issue {
    if (self != [QuickSpec current]) {
        [[QuickSpec current] recordIssue:issue];
        return;
    }

    if (self.example.isSharedExample) {
        XCTSourceCodeLocation *location = [[XCTSourceCodeLocation alloc] initWithFilePath:self.example.callsite.file
                                                                               lineNumber:self.example.callsite.line];
        XCTSourceCodeContext *sourceCodeContext = [[XCTSourceCodeContext alloc] initWithLocation:location];
        XCTIssue *newIssue = [[XCTIssue alloc] initWithType:issue.type
                                         compactDescription:issue.compactDescription
                                        detailedDescription:issue.detailedDescription
                                          sourceCodeContext:sourceCodeContext
                                            associatedError:issue.associatedError
                                                attachments:issue.attachments];
        [super recordIssue:newIssue];
    } else {
        [super recordIssue:issue];
    }
}

@end

#pragma mark - Test Observation

__attribute__((constructor))
static void registerQuickTestObservation(void) {
    [[XCTestObservationCenter sharedTestObservationCenter] addTestObserver:[QuickTestObservation sharedInstance]];
}
