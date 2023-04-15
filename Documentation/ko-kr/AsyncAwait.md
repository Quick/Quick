# Quick에서의 Async/Await

Quick 6.0.0 부터는 Swift 테스트가 모두 async context에서 실행됩니다. 즉, `beforeEach`, `afterEach`, `aroundEach`, `it`, `fit`, `xit` 에 전달되는 모든 클로저가 async/await를 지원한다는 것을 의미합니다. 이는 다음과 같은 코드가 가능하다는 것을 의미합니다:

```swift
describe("my awesome tests") {
    beforeEach {
        await someAsyncSetupFunction()
    }

    afterEach {
        await teardownButAsync()
    }
    
    aroundEach { runExample in
        await runExample()
    }

    it("can run tests asynchronously!") {
        let result = await methodBeingTested()
        expect(result).to(equal(expectedValue))
    }
}
```

이를 통해 [Actors](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html#ID645) 및 기타 async 함수를 원활하게 테스트할 수 있습니다.

## 메인 스레드에서 테스트 코드 실행하기

대부분의 경우, 테스트 코드가 메인 액터 또는 스레드에서 실행되는지 여부에 대해 걱정할 필요가 없습니다. 적절한 방법은 구현(또는 프로덕션) 코드를 메인 액터에서 실행하도록 태그하고, Swift의 런타임이 올바른 작업을 수행하도록 믿는 것입니다. 다음 코드에서 `codeTaggedToRunOnTheMainActor` 는 구현 코드를 대체합니다:

```swift
@MainActor
func codeTaggedToRunOnTheMainActor() {
    // 이것은 메인 액터에서 실행해야 하는 테스트 코드를 실행하는 선호되는 안전한 방법입니다: 타입 시스템을 사
    expect(Thread.isMainThread).to(beTrue())
}
it("will call async code that is tagged to run on the main actor") {
    expect(Thread.isMainThread).to(beFalse())
    await codeTaggedToRunOnTheMainActor()
}
```

그러나 때로는 메인 액터에서 실행해야하는 일부 동기 코드를 호출하고 싶을 수 있습니다. 이를 위한 두 가지 방법이 있습니다. 첫 번째는 `MainActor.run{body:}` 을 사용하는 것입니다. 이렇게 하면 코드가 메인 액터에서 실행되는 synchronous context 가 생성되며, 다음과 같이 설명됩니다.

```swift
it("will call synchronous code that needs to run on the main actor") {
    expect(Thread.isMainThread).to(beFalse())
    await MainActor.run {
        expect(Thread.isMainThread).to(beTrue())
    }
}
```

두 번째 방법은 Quick의 테스트 코드에 전달된 클로저에 `@MainActor` 태그를 지정하는 것입니다. 이 방법은 여전히 async context에서 코드를 실행하지만, 전달된 클로저는 메인 액터에서 실행됩니다.

```swift
it("will run code in an async context on the main actor") { @MainActor in
    expect(Thread.isMainThread).to(beTrue())
    await someOtherCode() // `someOtherCode` 는 `@MainActor` 로 태그되지 않은 이상 백그라운드 쓰레드에서 실행됩니다.
}
```

`beforeEach`, `afterEach`, `aroundEach` 도 정확히 동일한 방식으로 작동합니다.

## 스레드 안전성 문제

Quick은 여전히 `beforeEach`, `afterEach`, `aroundEach` 요소를 선언한 순서대로 실행하며, 중첩된 `describe`/`context`를 따릅니다. Quick은 테스트 내부의 요소를 병렬로 실행하지 않으므로 레이스 컨디션에 대해 걱정할 필요가 없습니다. 실행 스레드에 매우 의존적인 코드를 작성하지 않는 한 신경 쓸 필요가 없습니다. 또한, 실행 스레드에 따라 달라지는 코드를 작성한다면, 아마도 Actor로 다시 작성해야 할 것입니다.

변경된 것은 서로 다른 `beforeEach`, `afterEach`, `aroundEach` 또는 `it` 에서 사용된 테스트 코드가 동일한 스레드에서 실행될 것이라는 보장이 없다는 것입니다. 즉, 다음 테스트가 통과될 것을 보장할 수 없습니다.

```swift
describe("test threading") {
    var initialThread: Thread!
    beforeEach {
        initialThread = Thread.current
    }
    
    it("is not guranteed to run closures in the same test on the same thread") {
        expect(Thread.current).toNot(equal(initialThread)) // This test will sometimes fail and sometimes pass, depending on Swift version or even the platform it runs on.
    }
    
    it("is not guranteed to run closures on the test on different threads") {
        expect(Thread.current).to(equal(initialThread)) // This test will sometimes fail and sometimes pass, depending on Swift version or even the platform it runs on.
    }
}
```

모든 `beforeEach`/`afterEach`/`aroundEach`/`it` 클로저 사이에서 호출되는 코드가 모두 메인 스레드에서 실행되도록 보장하는 유일한 방법은 모든 클로저를 메인 스레드에서 실행하는 것입니다.

## Objective-C는 어떻게 되나요?

Objective-C는 Swift Concurrency 를 지원하지 않으므로 async/await을 사용할 수 없습니다. 이전 버전의 Quick과 마찬가지로, 모든 Objective-C 테스트 코드는 메인 스레드에서 실행됩니다. 주요 차이점은 Objective-C 테스트에서 `aroundEach` 를 더 이상 사용할 수 없다는 것입니다.

## Resources

- **[Swift Concurrency - The Swift Programming Language](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)**
- **[Meet Swift Concurrency - Apple WWDC 2021](https://developer.apple.com/news/?id=2o3euotz)**
- **[Swift Concurrency by Example - Paul Hudson, Hacking with Swift](https://www.hackingwithswift.com/quick-start/concurrency)**