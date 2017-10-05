# Configuring How Quick Behaves

`QuickConfiguration` 을 서브클래싱하거나 `QuickConfiguration.Type.configure()` 클래스 메소드를 오버라이드해서 퀵의 동작 방식을 커스터마이징 할 수 있습니다:

```swift
// Swift

import Quick

class ProjectDataTestConfiguration: QuickConfiguration {
  override class func configure(configuration: Configuration) {
    // ...configuration 객체에서 옵션을 여기서 지정하세요.
  }
}
```

```objc
// Objective-C

@import Quick;

QuickConfigurationBegin(ProjectDataTestConfiguration)

+ (void)configure:(Configuration *configuration) {
  // ...configuration 객체에서 옵션을 여기서 지정하세요.
}

QuickConfigurationEnd
```

프로젝트에는 몇 가지 설정이 포함될 수 있습니다. Quick은 이러한 설정이 실행되는 순서에 대해 어떠한 보장을 하지 않습니다.

## 글로벌 `beforeEach` 와 `afterEach` 클로저 추가하기

`QuickConfiguration.beforeEach` 와 `QuickConfiguration.afterEach`, 를 사용하여 테스트 슈트의 모든 예제 앞이나 뒤에 실행될 클로저를 지정할 수 있습니다 :

```swift
// Swift

import Quick
import Sea

class FinConfiguration: QuickConfiguration {
  override class func configure(configuration: Configuration) {
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

+ (void)configure:(Configuration *)configuration {
  [configuration beforeEach:^{
    [Dorsal sharedFin].height = 0;
  }];
}

QuickConfigurationEnd
```

또한, Quick은 현재 실행중인 예제와 관련된 메타데이터에 접근하는 것을 허용합니다 :

```swift
// Swift

import Quick

class SeaConfiguration: QuickConfiguration {
  override class func configure(configuration: Configuration) {
    configuration.beforeEach { exampleMetadata in
      // ...예제 메타데이터 객체를 사용하여 현재 예제 이름 등에 엑세스 하십시오.
    }
  }
}
```

```objc
// Objective-C

@import Quick;

QuickConfigurationBegin(SeaConfiguration)

+ (void)configure:(Configuration *)configuration {
  [configuration beforeEachWithMetadata:^(ExampleMetadata *data) {
    // ...예제 메타데이터 객체를 사용하여 현재 예제 이름 등에 엑세스 하십시오.
  }];
}

QuickConfigurationEnd
```
