# Async/Await in Quick

Quick 7.0.0 added `AsyncSpec` for defining tests of behavior utilizing
async/await. This is a change from the behavior in Quick 6. Now, tests only will
run in Async contexts when they are in a subclass of `AsyncSpec`. Tests in a
`QuickSpec` subclass will run in a synchronous context on the main thread, as
they did in Quick 5 and earlier.

This means that for `AsyncSpec` subclasses, all closures passed to `beforeEach`,
`afterEach`, `aroundEach`, `it`, `fit`, and `xit` support async/await. Meaning
the following code is possible:

```swift
final class MyAwesomeSpec: AsyncSpec {
    override class func spec() {
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
    }
}
```

This allows you to natively test
[Actors](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html#ID645)
and other async functions.

## Running test code on the main thread

When you do need to run test code on the main thread, the proper way is to tag
the relevant closure with `@MainActor`. For example, in the following code
`codeTaggedToRunOnTheMainActor` is a stand in for some implementation code:

```swift
func codeAssumedToRunOnTheMainThread() {
    expect(Thread.isMainThread).to(beTrue())
}
it("will call async code that is tagged to run on the main actor") { @MainActor in
    expect(Thread.isMainThread).to(beTrue())
    await codeTaggedToRunOnTheMainActor()
}
```

Alternatively, you can use `MainActor.run(body:)`. This will run the synchronous
code on the main actor:

```swift
it("will call synchronous code that needs to run on the main actor") {
    expect(Thread.isMainThread).to(beFalse())
    await MainActor.run {
        expect(Thread.isMainThread).to(beTrue())
    }
}
```

`beforeEach`, `afterEach` and `aroundEach` work in exactly the same manner.

Currently, Quick does not have a mechanism to have every `it`, `beforeEach`,
`afterEach`, `aroundEach` or `justBeforeEach` closure in an `AsyncSpec` to run
on the main actor. The only real way to do that is manually tag each closure
with `@MainActor in`, as shown in the earlier example. This is something we aim
to address in a future release.

## Thread Safety Concerns

Quick will still execute `beforeEach`, `afterEach`, `aroundEach` elements in the
order they're declared, following any nesting `describe`/`context`. Quick does
not execute elements within a test in parallel, so there are no race conditions
to worry about. Unless you are writing code that is very dependent on the thread
it executes on, then you should not care about this. And if you are writing code
that depends on the thread it uses, perhaps you should rewrite it to be an Actor?

What has changed is that there's no guarantee that test code used in different
`beforeEach`, `afterEach`, `aroundEach` or `it` elements will run on the same
thread. That is, you can't even guarantee that the following tests will pass:

```swift
final class ThreadingSpec: AsyncSpec {
    override class func spec() {
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
    }
}
```

The only way to guarantee that code called between all `beforeEach`,
`afterEach`, `aroundEach`, and `it` closures run on the same thread is to force
them all to run on the main thread. Even still, the test will not behave exactly
as it would in a `QuickSpec` subclass. This is because the test is an async
closure that is not tagged to run on the main actor which calls `beforeEach`,
`afterEach`, `aroundEach` and `it` closures. There will be a slight delay as the
system must switch from whichever default environment runs the test closure to
the main actor. This has been known to cause test flakiness if not taken into
account.

## What about Objective-C?

While it is possible to create Async specs in Objective-C, attempting to use the
Quick DSL in an AsyncSpec will cause a runtime crash. Do not attempt to do so.

## Resources

- **[Swift Concurrency - The Swift Programming Language](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)**
- **[Meet Swift Concurrency - Apple WWDC 2021](https://developer.apple.com/news/?id=2o3euotz)**
- **[Swift Concurrency by Example - Paul Hudson, Hacking with Swift](https://www.hackingwithswift.com/quick-start/concurrency)**
