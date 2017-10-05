# XCTest를 사용한 효과적인 테스트 : Arrange, Act, 그리고 Assert

XCTest, Quick, 또는 다른 테스트 프레임워크를 사용하는 경우, 간단한 패턴을 따라 효과적인 단위 테스트를 작성할 수 있습니다. :

1. Arrange
2. Act
3. Assert

## Arrange, Act, and Assert 사용하기

예를들어, `Banana` 라는 클래스를 간단히 살펴봅시다:

```swift
// Banana/Banana.swift

/** A delicious banana. Tastes better if you peel it first. */
public class Banana {
  private var isPeeled = false

  /** Peels the banana. */
  public func peel() {
    isPeeled = true
  }

  /** You shouldn't eat a banana unless it's been peeled. */
  public var isEdible: Bool {
    return isPeeled
  }
}
```

 `Banana.peel()`  메서드가 어떻게 되는지 확인해 봅시다:

```swift
// BananaTests/BananaTests.swift

class BananaTests: XCTestCase {
  func testPeel() {
    // Arrange: Create the banana we'll be peeling.
    let banana = Banana()

    // Act: Peel the banana.
    banana.peel()

    // Assert: Verify that the banana is now edible.
    XCTAssertTrue(banana.isEdible)
  }
}
```

## 깔끔한 테스트 이름 사용하기

`Banana.peel()` 메소드가 제대로 작동하지 않는다면,  `testPeel()` 을 통해 알 수 있습니다. 이는 일반적으로 응용 프로그램 코드가 변경되면서 발생합니다.

1. 우리는 뜻하지 않게 응용 프로그램 코드를 망가트리므로, 응용 프로그램 코드를 수정해야 합니다.
2. 우리는 응용 프로그램의 작동 방식을 변경했습니다. — 아마도 새로운 기능을 추가했기 때문일 수 있습니다. — 그래서 우리는 테스트 코드를 변경해야 합니다. 

만약 우리의 테스트가 중단되기 시작한다면, 어떤 케이스가 적용되었는지 어떻게 알 수 있을까요? 이는 **테스트의 이름**이 우리의 최선의 표시라는 사실을 알려줍니다. 좋은 테스트 이름들 :

1. 테스트 대상에 대해 명확합니다.
2. 테스트가 통과하거나 실패하는 시기에 대해 명확합니다.

 `testPeel()` 메소드는 명확한 이름을 가지고 있나요? 더 명확하게 바꾸어 봅시다:

```diff
// BananaTests.swift

-func testPeel() {
+func testPeel_makesTheBananaEdible() {
  // Arrange: Create the banana we'll be peeling.
  let banana = Banana()

  // Act: Peel the banana.
  banana.peel()

  // Assert: Verify that the banana is now edible.
  XCTAssertTrue(banana.isEdible)
}
```

새로운 이름:

1. 테스트 대상에 대해 명확합니다 : `testPeel` 은  `Banana.peel()` 메소드 임을 나타냅니다.
2. 테스트가 통과하거나 실패하는 시기에 대해 명확합니다 : `makesTheBananaEdible` 는 메소드가 호출되면 바나나가 식용 가능한 상태임을 나타냅니다.

## Testing Conditions

`offer()` 함수를 사용해서 사람들에게 바나나를 제공하고 싶다고 가정해 보겠습니다 :

```swift
// Banana/Offer.swift

/** Given a banana, returns a string that can be used to offer someone the banana. */
public func offer(banana: Banana) -> String {
  if banana.isEdible {
    return "Hey, want a banana?"
  } else {
    return "Hey, want me to peel this banana for you?"
  }
}
```

우리의 프로그램 코드는 다음 두 가지 중 하나를 수행합니다 :

1. 이미 벗겨진 바나나를 제공합니다...
2. …또는 벗져기기 않은 바나나를 제공합니다.

이 두가지 경우에 대한 테스트를 작성해 봅시다 :

```swift
// BananaTests/OfferTests.swift

class OfferTests: XCTestCase {
  func testOffer_whenTheBananaIsPeeled_offersTheBanana() {
    // Arrange: Create a banana and peel it.
    let banana = Banana()
    banana.peel()

    // Act: Create the string used to offer the banana.
    let message = offer(banana)

    // Assert: Verify it's the right string.
    XCTAssertEqual(message, "Hey, want a banana?")
  }

  func testOffer_whenTheBananaIsntPeeled_offersToPeelTheBanana() {
    // Arrange: Create a banana.
    let banana = Banana()

    // Act: Create the string used to offer the banana.
    let message = offer(banana)

    // Assert: Verify it's the right string.
    XCTAssertEqual(message, "Hey, want me to peel this banana for you?")
  }
}
```

테스트 이름은 테스트가 통과해야 하는 **조건**을 명확하게 나타내야 합니다 : 예를들면 `whenTheBananaIsPeeled`, `offer()` 은 `offersTheBanana` 가 되어야 합니다. 만약 바나나가 벗겨지지 않은 경우라도 우리는 역시 이 경우를 테스트했습니다!

코드에서 `if`문 하나에 테스트가 하나씩 가지고 있는 것을 주목해 봅시다. 이것은 테스트를 작성할 때 훌륭한 패턴 입니다 : 이 패턴은 모든 조건 셋이 테스트되는지 확인할 수 있습니다.  이러한 조건 중 하나가 더 이상 작동하지 않거나 변경이 필요 없게 된다면, 우리는 어떤 검사가 필요한지 정확히 알 수 있게 됩니다.

## `XCTestCase.setUp()` 을 사용하여 "Arrange" 짧게 하기

우리의 `OfferTests` 에는 같은 "Arrange" 코드가 포함되어 있습니다 : 이들은 둘다 바나나를 만듭니다. 우리는 이 코드를 한 곳으로 움직여야만 합니다. 왜일까요?

1. 그대로, `바나나` 이니셜라이저를 변경하면, 모든 바나나를 만드는 테스트들을 수정해야합니다. 
2. 우리의 테스트 메소드는 짧을 것입니다. — 테스트를 더 쉽게 읽을 수 있도록 만든다면 (그리고 **만드는 경우에만** ) 더 좋은 것일 겁니다.

`바나나` 초기화 코드를 모든 테스트 메소드 전에 한 번 실행되는  `XCTestCase.setUp()` 안으로 옮기세요.

```swift
// OfferTests.swift

class OfferTests: XCTestCase {
+  var banana: Banana!
+
+  override func setUp() {
+    super.setUp()
+    banana = Banana()
+  }
+
  func testOffer_whenTheBananaIsPeeled_offersTheBanana() {
-    // Arrange: Create a banana and peel it.
-    let banana = Banana()
+    // Arrange: Peel the banana.
    banana.peel()

    // Act: Create the string used to offer the banana.
    let message = offer(banana)

    // Assert: Verify it's the right string.
    XCTAssertEqual(message, "Hey, want a banana?")
  }

  func testOffer_whenTheBananaIsntPeeled_offersToPeelTheBanana() {
-    // Arrange: Create a banana.
-    let banana = Banana()
-
    // Act: Create the string used to offer the banana.
    let message = offer(banana)

    // Assert: Verify it's the right string.
    XCTAssertEqual(message, "Hey, want me to peel this banana for you?")
  }
}
```

## "Arrange" 코드를 여러 테스트에서 공유하기

여러 테스트 간에 동일한 "arrange" 스텝을 사용하는 자신을 발견하게 된다면, 당신은 헬퍼 함수를 테스트 대상에 정의할 수 있습니다 :

```swift
// BananaTests/BananaHelpers.swift

internal func createNewPeeledBanana() -> Banana {
  let banana = Banana()
  banana.peel()
  return banana
}
```

> 함수를 사용하여 헬퍼를 정의하십시오 : 함수는 서브클래스화 할 수 없으며, 어떤 상태도 유지할 수 없습니다. 서브 클래스화 및 변경 가능한 상태는 당신의 테스트를 읽기 힘들게 합니다.
