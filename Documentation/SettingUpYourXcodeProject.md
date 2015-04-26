# Setting Up Tests in Your Xcode Project

When you create a new project in Xcode 6, a unit test target is included
by default. To write unit tests, you'll need to be able to use your main
target's code from within your test target.

## Testing Swift Code Using Swift

In order to test code written in Swift, you'll need to do three things:

1. Set "defines module" in your `.xcodeproj` to `YES`.

  * To do this in Xcode: Choose your project, then "Build Settings" header, then "Defines Modules" line, then select "Yes".

2. Mark any class/method/function you want to test `public`, since only
   `public` symbols are exported.
3. `import YourAppModuleName` in your unit tests.

```swift
// MyAppTests.swift

import XCTest
import MyModule

class MyClassTests: XCTestCase {
  // ...
}
```

> Some developers advocate adding Swift source files to your test target.
However, this leads to [subtle, hard-to-diagnose
errors](https://github.com/Quick/Quick/issues/91), and is not
recommended.

## Testing Objective-C Code Using Swift

1. Add a bridging header to your test target.
2. In the bridging header, import the file containing the code you'd like to test.

```objc
// MyAppTests-BridgingHeader.h

#import "MyClass.h"
```

You can now use the code from `MyClass.h` in your Swift test files.

## Testing Swift Code Using Objective-C

1. Bridge Swift classes and functions you'd like to test to Objective-C by
   using the `@objc` attribute.
2. Import your module's Swift headers in your unit tests.

```objc
#import <XCTest/XCTest.h>
#import "MyModule-Swift.h"

@interface MyClassTests: XCTestCase
// ...
@end
```

## Testing Objective-C Code Using Objective-C

Import the file defining the code you'd like to test from within your test target:

```objc
// MyAppTests.m

#import <XCTest/XCTest.h>
#import "MyClass.h"

@interface MyClassTests: XCTestCase
// ...
@end
```
