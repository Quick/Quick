# Async/Await in Quick

Starting in Quick 6.0.0, all Swift tests now run in an async context. This means that all closures passed to `beforeEach`, `afterEach`, `aroundEach`, `it`, `fit`, and `xit` support async/await. Meaning the following code is now possible:

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

This allows you to natively test [Actors](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html#ID645) and other async functions.

## Running test code on the main thread

In most cases, you don't need to care about whether your test code runs on the main actor or thread. The proper way is to tag your implementation (or production) code to run on the main actor, and trust Swift's runtime to do the right thing. For example, in the following code `codeTaggedToRunOnTheMainActor` is a stand in for some implementation code:

```swift
@MainActor
func codeTaggedToRunOnTheMainActor() {
    // this is the prefered and safe method to test code that much run on the main actor: Use the type system.
    expect(Thread.isMainThread).to(beTrue())
}
it("will call async code that is tagged to run on the main actor") {
    expect(Thread.isMainThread).to(beFalse())
    await codeTaggedToRunOnTheMainActor()
}
```

However, sometimes, you want to call some synchronous code that must run on the main actor. There are two ways to do this. First is to use `MainActor.run{body:}`. This creates a synchronous context for code to run on the main actor, and is demonstrated below.

```swift
it("will call synchronous code that needs to run on the main actor") {
    expect(Thread.isMainThread).to(beFalse())
    await MainActor.run {
        expect(Thread.isMainThread).to(beTrue())
    }
}
```

The second way is to tag the closure passed to Quick's test code with `@MainActor`. This is still executes code within an async context, just now the passed in closure will run on the main actor.

```swift
it("will run code in an async context on the main actor") { @MainActor in
    expect(Thread.isMainThread).to(beTrue())
    await someOtherCode() // `someOtherCode` will run on a background thread unless it is tagged with `@MainActor`.
}
```

Of course, `beforeEach`, `afterEach` and `aroundEach` work in exactly the same manner.

## Thread Safety Concerns

Quick will still execute `beforeEach`, `afterEach`, `aroundEach` elements in the order they're declared, following any nesting `describe`/`context`. Quick does not execute elements within a test in parallel, so there are no race conditions to worry about. Unless you are writing code that is very dependent on the thread it executes on, then you should not care about this. And if you are writing code that depends on the thread it uses, perhaps you should rewrite it to be an Actor?

What has changed is that there's no guarantee that test code used in different `beforeEach`, `afterEach`, `aroundEach` or `it` elements will run on the same thread. That is, you can't even guarantee that the following tests will pass:

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

The only way to guarantee that code called between all `beforeEach`/`afterEach`/`aroundEach`/`it` closures is to force them all to run on the main thread.

## What about Objective-C?

Objective-C does not support Swift Concurrency, so you can't use async/await in it. All Objective-C test code will run on the main thread, same as in earlier versions of Quick. The main difference is that `aroundEach` is no longer available in Objective-C tests.

## Resources

- **[Swift Concurrency - The Swift Programming Language](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)**
- **[Meet Swift Concurrency - Apple WWDC 2021](https://developer.apple.com/news/?id=2o3euotz)**
- **[Swift Concurrency by Example - Paul Hudson, Hacking with Swift](https://www.hackingwithswift.com/quick-start/concurrency)**