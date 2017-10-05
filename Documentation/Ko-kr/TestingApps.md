# OS X 와 iOS 앱 테스트

*[Xcode 프로젝트에 Test 설정하기](SettingUpYourXcodeProject.md)*
Objective-C 또는 Swift 함수와 클래스를 테스트하기 위해 알아야할 모든 것을 다룹니다.
이 섹션에서는, `UIViewController` 하위 클래스와 같은 클래스를 테스트 하기 위한 몇 가지 추가적인 힌트를 살펴 보겠습니다.

> 이 주제들을 다루는 라이트닝 토크를 [이곳](https://vimeo.com/115671189#t=37m50s) 에서 볼 수 있습니다. (37분 50초 쯤 시작합니다.).

## `UIViewController` 라이프 사이클 이벤트 트리거

일반적으로, UIKit은 뷰 컨트롤러의 라이프사이클 이벤트를 앱 내에서 표시할 때 트리거합니다.  그러나, `UIViewController`가 테스트 될 때, 이러한 `UIViewController`를 직접 트리거해야 합니다. 다음 3가지 방법 중 하나로 할 수 있습니다:

1. `UIViewController.viewDidLoad()` 같은 것을 트리거하는 `UIViewController.view`에 액세스하기.
2. `UIViewController.beginAppearanceTransition()` 을 사용하여 대부분의 라이프사이클 이벤트를 트리거하기.
3. `UIViewController.viewDidLoad()` 또는 `UIViewController.viewWillAppear()` 와 같은 메서드를 직접 호출하기.

```swift
// Swift

import Quick
import Nimble
import BananaApp

class BananaViewControllerSpec: QuickSpec {
  override func spec() {
    var viewController: BananaViewController!
    beforeEach {
      viewController = BananaViewController()
    }

    describe(".viewDidLoad()") {
      beforeEach {
        // Method #1: 뷰에 액세스하여 BananaViewController.viewDidLoad() 를 트리거합니다.
        let _ =  viewController.view
      }

      it("바나나 카운트 레이블을 0으로 설정한다.") {
        // 뷰가 로드 될 때, 레이블만 초기화되기 때문에 위의 `beforeEach`에서 뷰에 액세스하지 않으면 레이블이 초기화 되지 않습니다. 
        expect(viewController.bananaCountLabel.text).to(equal("0"))
      }
    }

    describe("뷰") {
      beforeEach {
        // Method #2: .viewDidLoad(), .viewWillAppear(), 그리고 .viewDidAppear() 이벤트를 트리거한다.
        viewController.beginAppearanceTransition(true, animated: false)
        viewController.endAppearanceTransition()
      }
      // ...
    }

    describe(".viewWillDisappear()") {
      beforeEach {
        // Method #3: 라이프사이클 메소드를 직접호출 한다.
        viewController.viewWillDisappear(false)
      }
      // ...
    }
  }
}
```

```objc
// Objective-C

@import Quick;
@import Nimble;
#import "BananaViewController.h"

QuickSpecBegin(BananaViewControllerSpec)

__block BananaViewController *viewController = nil;
beforeEach(^{
  viewController = [[BananaViewController alloc] init];
});

describe(@"-viewDidLoad", ^{
  beforeEach(^{
    // Method #1: 뷰에 액세스하여 트리거한다 -[BananaViewController viewDidLoad].
    [viewController view];
  });

  it(@"바나나 카운트 레이블을 0으로 설정한다", ^{
    // 뷰가 로드 될 때, 레이블만 초기화되기 때문에 위의 `beforeEach`에서 뷰에 액세스하지 않으면 레이블이 초기화 되지 않습니다. 
    expect(viewController.bananaCountLabel.text).to(equal(@"0"))
  });
});

describe(@"the view", ^{
  beforeEach(^{
    // Method #2: .viewDidLoad(), .viewWillAppear(), 그리고 .viewDidAppear() 이벤트를 트리거한다.
    [viewController beginAppearanceTransition:YES animated:NO];
    [viewController endAppearanceTransition];
  });
  // ...
});

describe(@"-viewWillDisappear", ^{
  beforeEach(^{
    // Method #3: 라이프사이클 메소드를 직접호출 한다.
    [viewController viewWillDisappear:NO];
  });
  // ...
});

QuickSpecEnd
```

## 스토리 보드에 정의된 뷰 컨트롤러를 초기화 하기

스토리보드에 정의된 뷰 컨트롤러를 초기화하기 위해서는, **Storyboard ID**를 뷰 컨트롤러에 지정해야 합니다:

![](http://f.cl.ly/items/2X2G381K1h1l2B2Q0g3L/Screen%20Shot%202015-02-27%20at%2011.58.06%20AM.png)

그렇게 하면, 테스트 내에서 뷰 컨트롤러를 인스턴스화 할 수 있습니다:

```swift
// Swift

var viewController: BananaViewController!
beforeEach {
  // 1. 스토리보드를 인스턴스화 합니다. 기본적으로 이름은"Main.storyboard" 입니다.
  //    스토리보드 이름이 예제와 다른 경우 여기에 다른 문자열을 사용하세요.
  let storyboard = UIStoryboard(name: "Main", bundle: nil)
  // 2. 스토리보드를 사용하여 뷰 컨트롤러를 인스턴스화 합니다.
  viewController = 
    storyboard.instantiateViewControllerWithIdentifier(
      "BananaViewControllerID") as! BananaViewController
}
```

```objc
// Objective-C

__block BananaViewController *viewController = nil;
beforeEach(^{
  // 1. 스토리보드를 인스턴스화 합니다. 기본적으로 이름은"Main.storyboard" 입니다.
  //    스토리보드 이름이 예제와 다른 경우 여기에 다른 문자열을 사용하세요.
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  // 2. 스토리보드를 사용하여 뷰 컨트롤러를 인스턴스화 합니다.
  viewController = [storyboard instantiateViewControllerWithIdentifier:@"BananaViewControllerID"];
});
```

## Button 탭과 같은 UIControl 이벤트 트리거

버튼과 다른 UIKit 클래스는 버튼 탭과 같이 프로그래밍적인 방법으로 컨트롤 이벤트를 보낼 수 있는 메소드를 정의하는 `UIControl`을 상속합니다. 
버튼을 누를 때 발생하는 동작을 테스트하려면 다음과 같이 작성할 수 있습니다:

```swift
// Swift

describe("'더 많은 바나나' 버튼 누름") {
  it("버튼이 눌리면 바나나 카운트 라벨을 증가시킨다.") {
    viewController.moreButton.sendActionsForControlEvents(
      UIControlEvents.TouchUpInside)
    expect(viewController.bananaCountLabel.text).to(equal("1"))
  }
}
```

```objc
// Objective-C

describe(@"'더 많은 바나나' 버튼 누름", ^{
  it(@"버튼이 눌리면 바나나 카운트 라벨을 증가시킨다.", ^{
    [viewController.moreButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    expect(viewController.bananaCountLabel.text).to(equal(@"1"));
  });
});
```
