# Quickの挙動をカスタマイズしましょう

`QuickConfiguration` を継承したクラスを作成し、`QuickConfiguration.Type.configure()` をオーバーライドすることで Quick の挙動をカスタマイズすることができます。

```swift
// Swift

import Quick

class ProjectDataTestConfiguration: QuickConfiguration {
  override class func configure(configuration: QCKConfiguration) {
    // ...set options on the configuration object here.
  }
}
```

```objc
// Objective-C

@import Quick;

QuickConfigurationBegin(ProjectDataTestConfiguration)

+ (void)configure:(QCKConfiguration *configuration) {
  // ...set options on the configuration object here.
}

QuickConfigurationEnd
```

一つのプロジェクトで複数の configuration を持つこともできますが
どの順に configuration が実行されるか保証されません。

## テスト全体で使う `beforeEach` と `afterEach` を追加する

`QuickConfiguration.beforeEach` と `QuickConfiguration.afterEach` を使うと
テストスイート内の各テストの実行前・実行後に走らせる処理を記述することができます。

```swift
// Swift

import Quick
import Sea

class FinConfiguration: QuickConfiguration {
  override class func configure(configuration: QCKConfiguration) {
    configuration.beforeEach {
      Dorsal.sharedFin().height = 0
    }
  }
}
```

```objc
// Objective-C

@import Quick;
#import "Dorsal.h"

QuickConfigurationBegin(FinConfiguration)

+ (void)configure:(QCKConfiguration *)configuration {
  [configuration beforeEach:^{
    [Dorsal sharedFin].height = 0;
  }];
}

QuickConfigurationEnd
```

さらに現在実行中のテストに関するメタデータを取得することもできます。

```swift
// Swift

import Quick

class SeaConfiguration: QuickConfiguration {
  override class func configure(configuration: QCKConfiguration) {
    configuration.beforeEach { exampleMetadata in
      // ...use the example metadata object to access the current example name, and more.
    }
  }
}
```

```objc
// Objective-C

@import Quick;

QuickConfigurationBegin(SeaConfiguration)

+ (void)configure:(QCKConfiguration *)configuration {
  [configuration beforeEachWithMetadata:^(ExampleMetadata *data) {
    // ...use the example metadata object to access the current example name, and more.
  }];
}

QuickConfigurationEnd
```
