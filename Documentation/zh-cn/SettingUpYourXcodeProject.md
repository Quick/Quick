# 在项目中添加测试

除了命令行项目以外, 当你在Xcode 7中创建新项目时, 单元测试Target默认是包含的. [为命令行项目设置测试Target](#setting-up-a-test-target-for-a-command-line-tool-project). 要编写单元测试, 你需要能够在测试Target中使用主target代码.

## 用Swift测试Swift项目代码

为了测试用Swift写的代码, 你需要做以下两件事:

1. 将`.xcodeproj`中的 "defines module" 设置为 `YES`.

  * Xcode中具体操作方法: 选中你的项目, 选择 "Build Settings" 选项列表, 选中 "Defines Modules" 行, 修改其值为 "Yes".

2. 在单元测试中添加 `@testable import YourAppModuleName`. 这会把所有 `public` 和 `internal` (默认访问修饰符) 修饰符暴露给测试代码. 但`private` 修饰符仍旧保持私有.

```swift
// MyAppTests.swift

import XCTest
@testable import MyModule

class MyClassTests: XCTestCase {
  // ...
}
```

> 一些开发者提倡添加Swift源文件至测试target. 然而这会导致以下问题 [subtle, hard-to-diagnose errors](https://github.com/Quick/Quick/issues/91), 所以并不推荐.

## 使用Swift测试Objective-C项目代码

1. 给你的测试target添加bridging header文件.
2. 在bridging header文件中, 引入待测试的代码文件.

```objc
// MyAppTests-BridgingHeader.h

#import "MyClass.h"
```

现在就可以在Swift测试文件中使用 `MyClass.h` 中的代码了

## 使用Objective-C测试Swift项目代码

1. 使用 `@objc` 桥接需要使用Objective-C测试的Swift类和方法.
2. 在单元测试中引入模块的Swift头文件.

```objc
@import XCTest;
#import "MyModule-Swift.h"

@interface MyClassTests: XCTestCase
// ...
@end
```

## 使用Objective-C测试Objective-C项目代码

在测试target中引入待测试的代码文件:

```objc
// MyAppTests.m

@import XCTest;
#import "MyClass.h"

@interface MyClassTests: XCTestCase
// ...
@end
```

### 为命令行项目设置测试Target

1. 在项目窗格中添加一个项目target.
2. 选择 "OS X Unit Testing Bundle".
3. 编辑主target的 scheme.
4. 选中 "Test" 条目, 单击 "Info" 下的 "+", 选择需要测试的 bundle.
