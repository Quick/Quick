# Quick

A behavior-driven development framework for Swift and Objective-C. Inspired by [RSpec](https://github.com/rspec/rspec), [Specta](https://github.com/specta/specta), and [Ginkgo](https://github.com/onsi/ginkgo).

![](http://f.cl.ly/items/2F362k2E3f0u2R0p3q1c/Screen%20Shot%202014-06-14%20at%208.16.22%20PM.png)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Quick Core: Examples and Example Groups](#quick-core-examples-and-example-groups)
  - [Examples Using `it`](#examples-using-it)
  - [Example Groups Using `describe` and `context`](#example-groups-using-describe-and-context)
    - [Describing Classes and Methods Using `describe`](#describing-classes-and-methods-using-describe)
    - [Sharing Setup/Teardown Code Using `beforeEach` and `afterEach`](#sharing-setupteardown-code-using-beforeeach-and-aftereach)
    - [Specifying Conditional Behavior Using `context`](#specifying-conditional-behavior-using-context)
  - [Temporarily Disabling Examples or Groups Using `pending`](#temporarily-disabling-examples-or-groups-using-pending)
  - [Global Setup/Teardown Using `beforeSuite` and `afterSuite`](#global-setupteardown-using-beforesuite-and-aftersuite)
- [Quick Expectations: Assertions Using `expect(...).to`](#quick-expectations-assertions-using-expectto)
  - [Automatic Optional Unwrapping](#automatic-optional-unwrapping)
  - [Asynchronous Expectations Using `will` and `willNot`](#asynchronous-expectations-using-will-and-willnot)
- [How to Install Quick and Quick Expectations](#how-to-install-quick-and-quick-expectations)
  - [1. Clone this repository](#1-clone-this-repository)
  - [2. Add the `Quick.xcodeproj` file to your application's test target](#2-add-the-quickxcodeproj-file-to-your-applications-test-target)
  - [3. Link the `Quick.framework`](#3-link-the-quickframework)
  - [4. Start writing specs!](#4-start-writing-specs!)
- [Who Uses Quick](#who-uses-quick)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Quick Core: Examples and Example Groups

Quick uses a special syntax that allows me to define **examples** and
**example groups**.

### Examples Using `it`

Examples use assertions to demonstrate how code should behave.
These are like "tests" in XCTest.

Quick allows me to define examples using `it`. `it` also takes a string,
which serves as a description of the example.

```swift
// Swift

import Quick

class DolphinSpec: QuickSpec {
    override func exampleGroups() {
        it("is friendly") {
            expect(dolphin!.isFriendly).to.beTrue()
        }

        it("is smart") {
            expect(dolphin!.isSmart).to.beTrue()
        }
    }
}
```

```objc
// Objective-C

#import <Quick/Quick.h>

QuickSpecBegin(DolphinSpec)

qck_it(@"is friendly", ^{
    XCTAssertTrue(dolphin.isFriendly, @"expected dolphin to be friendly");
});

qck_it(@"is smart", ^{
    XCTAssertTrue(dolphin.isSmart, @"expected dolphin to be smart");
});

QuickSpecEnd
```

> Descriptions can use any character, including characters from languages
  besides English, or even emoji! :v: :sunglasses:

### Example Groups Using `describe` and `context`

Example groups are logical groupings of examples. By grouping similar
examples together, we can share setup and teardown code between them.

#### Describing Classes and Methods Using `describe`

Let's say I want to specify the behavior of my `Dolphin` class's `click`
method (or, in other words, I want to test the method works). I can
group all of the tests for `click` using `describe`.

```swift
// Swift

import Quick

class DolphinSpec: QuickSpec {
    override func exampleGroups() {
        describe("a dolphin") {
            describe("its click") {
                it("is loud") {
                    let click = Dolphin().click()
                    expect(click.isLoud).to.beTrue()
                }

                it("has a high frequency") {
                    let click = Dolphin().click()
                    expect(click.hasHighFrequency).to.beTrue()
                }
            }
        }
    }
}
```

```objc
// Objective-C

#import <Quick/Quick.h>

QuickSpecBegin(DolphinSpec)

qck_describe(@"a dolphin", ^{
    qck_describe(@"its click", ^{
        qck_it(@"is loud", ^{
            Click *click = [[Dolphin new] click];
            XCTAssertTrue(click.isLoud, @"expected dolphin click to be loud");
        });

        qck_it(@"has a high frequency", ^{
            Click *click = [[Dolphin new] click];
            XCTAssertTrue(click.hasHighFrequency,
                @"expected dolphin click to have a high frequency");
        });
    });
});

QuickSpecEnd
```

#### Sharing Setup/Teardown Code Using `beforeEach` and `afterEach`

Besides making the intention of my examples clearer, example groups
like `describe` allow me to share setup and teardown code among my
examples.

Using `beforeEach`, I can create a new instance of a dolphin and its
click before each one of my examples. This ensures that both are in a
"fresh" state for every example.

```swift
// Swift

import Quick

class DolphinSpec: QuickSpec {
    override func exampleGroups() {
        describe("a dolphin") {
            var dolphin: Dolphin?
            beforeEach {
                dolphin = Dolphin()
            }

            describe("its click") {
                var click: Click?
                beforeEach {
                    click = dolphin!.click()
                }

                it("is loud") {
                    expect(click!.isLoud).to.beTrue()
                }

                it("has a high frequency") {
                    expect(click!.hasHighFrequency).to.beTrue()
                }
            }
        }
    }
}
```

```objc
// Objective-C

#import <Quick/Quick.h>

QuickSpecBegin(DolphinSpec)

qck_describe(@"a dolphin", ^{
    __block Dolphin *dolphin = nil;
    qck_beforeEach(^{
        dolphin = [Dolphin new];
    });

    qck_describe(@"its click", ^{
        __block Click *click = nil;
        qck_beforeEach(^{
            click = [dolphin click];
        });

        qck_it(@"is loud", ^{
            XCTAssertTrue(click.isLoud, @"expected dolphin click to be loud");
        });

        qck_it(@"has a high frequency", ^{
            XCTAssertTrue(click.hasHighFrequency,
                @"expected dolphin click to have a high frequency");
        });
    });
});

QuickSpecEnd
```

Sharing setup like this might not seem like such a big deal with my
dolphin example, but for more complicated objects, it saves me a lot
of typing!

To execute code *after* each example, use `afterEach`.

#### Specifying Conditional Behavior Using `context`

Dolphins use clicks for echolocation. When they approach something
particularly interesting to them, they release a series of clicks in
order to get a better idea of that it is.

I want to show that my `click` method behaves differently in different
circumstances. Normally, the dolphin just clicks once. But when the dolphin
is close to something interesting, it clicks several times.

I can express this in my tests by using `context`: one `context` for the
normal case, and one `context` for when the dolphin is close to
something interesting.

```swift
// Swift

import Quick

class DolphinSpec: QuickSpec {
    override func exampleGroups() {
        describe("a dolphin") {
            var dolphin: Dolphin?
            beforeEach { dolphin = Dolphin() }

            describe("its click") {
                context("when the dolphin is not near anything interesting") {
                    it("is only emitted once") {
                        expect(dolphin!.click().count).to.equal(1)
                    }
                }

                context("when the dolphin is near something interesting") {
                    beforeEach {
                        let ship = SunkenShip()
                        Jamaica.dolphinCove.add(ship)
                        Jamaica.dolphinCove.add(dolphin)
                    }

                    it("is emitted three times") {
                        expect(dolphin!.click().count).to.equal(3)
                    }
                }
            }
        }
    }
}
```

```objc
// Objective-C

#import <Quick/Quick.h>

QuickSpecBegin(DolphinSpec)

qck_describe(@"a dolphin", ^{
    __block Dolphin *dolphin = nil;
    qck_beforeEach(^{ dolphin = [Dolphin new]; });

    qck_describe(@"its click", ^{
        qck_context(@"when the dolphin is not near anything interesting", ^{
            qck_it(@"is only emitted once", ^{
                XCTAssertEqual([[dolphin click] count], 1,
                    @"expected dolphin click to be emitted once");
            });
        });

        qck_context(@"when the dolphin is near something interesting", ^{
            qck_beforeEach(^{
                [[Jamaica dolphinCove] add:[SunkenShip new]];
                [[Jamaica dolphinCove] add:dolphin];
            });

            qck_it(@"is emitted three times", ^{
                XCTAssertEqual([[dolphin click] count], 3,
                    @"expected dolphin click to be emitted three times");
            });
        });
    });
});

QuickSpecEnd
```

### Temporarily Disabling Examples or Groups Using `pending`

I can also use `pending` in Swift, or `qck_pending` in Objective-C, to
denote an example that does not pass yet. Pending blocks are not run,
but are printed out along with the test results.

For example, I haven't yet implemented the `click` method to emit a
series of clicks when the dolphin is near something interesting. So I
will mark that example group as pending for now:

```swift
// Swift

pending("when the dolphin is near something interesting") {
    // ...none of the code in this closure will be run.
}
```

```objc
// Objective-C

qck_pending(@"when the dolphin is near something interesting", ^{
    // ...none of the code in this closure will be run.
});
```

### Global Setup/Teardown Using `beforeSuite` and `afterSuite`

I sometimes need to perform some setup before *any* of my examples are
run. Let's say I maintain a database that keeps track of everything in
the ocean. I want to create a new test database before any of my
examples run. I also want to get rid of that database once my examples
are finished running.

Quick allows me to do this by using `beforeSuite` and `afterSuite`.

```swift
// Swift

import Quick

class DolphinSpec: QuickSpec {
    override func exampleGroups() {
        beforeSuite {
            OceanDatabase.createDatabase(name: "test.db")
            OceanDatabase.connectToDatabase(name: "test.db")
        }

        afterSuite {
            OceanDatabase.teardownDatabase(name: "test.db")
        }

        describe("a dolphin") {
            // ...
        }
    }
}
```

```objc
// Objective-C

#import <Quick/Quick.h>

QuickSpecBegin(DolphinSpec)

qck_beforeSuite(^{
    [OceanDatabase createDatabase:@"test.db"];
    [OceanDatabase connectToDatabase:@"test.db"];
});

qck_afterSuite(^{
    [OceanDatabase teardownDatabase:@"test.db"];
});

qck_describe(@"a dolphin", ^{
    // ...
});

QuickSpecEnd
```

I can specify as many `beforeSuite` and `afterSuite` as I like. All
`beforeSuite` will be executed before any tests, and all `afterSuite`
will be executed after all tests are finished. There's no guarantee as
to what order they will be executed in, however.

## Quick Expectations: Assertions Using `expect(...).to`

> Currently Quick expectations are only available in Swift.
  See https://github.com/modocache/Quick/issues/26 for more details.

Quick expectations use the `expect(...).to` syntax:

```swift
expect(person!.greeting).to.equal("Oh, hi.")
expect(person!.greeting).notTo.equal("Hello!")
```

Quick includes matchers that test whether the subject of an
expectation is true, or equal to something, or whether it
contains a specific element:

```swift
expect(person!.isHappy).to.beTrue()
expect(person!.greeting).to.equal("Hello!")
expect(person!.hopes).to.contain("winning the lottery")
```

### Automatic Optional Unwrapping

When passing an optional to an expectation, there's no need to unwrap the
variable using a trailing `!`: Quick does that for me.

```swift
var optVal: Int?

expect(optVal).to.beNil()

optVal = 123

expect(optVal).toNot.beNil()
expect(optVal).to.equal(123)
```

### Asynchronous Expectations Using `will` and `willNot`

Quick also allows for asynchronous expectations, by wrapping the subject
in braces instead of parentheses. This allows the subject to be
evaluated as a closure. Below is an example of a subject who knows
only hunger, and never satisfaction:

```swift
expect{person!.isHungry}.will.beTrue()
expect{person!.isSatisfied}.willNot.beTrue()
```

Asynchronous expectations time out after one second by default. I can
extend this default by using `willBefore`. The following times out after 3
seconds:

```swift
expect{person!.isHungry}.willBefore(3).beTrue()
expect{person!.isSatisfied}.willNotBefore(3).beTrue()
```

## How to Install Quick and Quick Expectations

> This module is beta software, and can only run using the latest, beta version
of Xcode.

To use Quick to test your iOS or OS X applications, follow these 4 easy steps:

1. [Clone the repository](https://github.com/modocache/Quick#1-clone-this-repository)
2. [Add `Quick.xcodeproj` to your test target](https://github.com/modocache/Quick#2-add-the-quickxcodeproj-file-to-your-applications-test-target)
3. [Link `Quick.framework` during your test target's `Link Binary with Libraries` build phase](https://github.com/modocache/Quick#3-link-the-quickframework)
4. Start writing specs!

An example project with this complete setup is available in the
[`Examples`](https://github.com/modocache/Quick/tree/master/Examples) directory.

### 1. Clone this repository

```
git clone git@github.com:modocache/Quick.git
```

### 2. Add the `Quick.xcodeproj` file to your application's test target

Right-click on the group containing your application's tests and
select `Add Files To YourApp...`.

![](http://cl.ly/image/3m110l2s0a18/Screen%20Shot%202014-06-08%20at%204.25.59%20AM.png)

Next, select `Quick.xcodeproj`, which you downloaded in step 1.

![](http://cl.ly/image/431F041z3g1P/Screen%20Shot%202014-06-08%20at%204.26.49%20AM.png)

Once you've added the Quick project, you should see it in Xcode's project
navigator, grouped with your tests.

![](http://cl.ly/image/0p0k2F2u2O3I/Screen%20Shot%202014-06-08%20at%204.27.29%20AM%20copy.png)

### 3. Link the `Quick.framework`

Finally, link the `Quick.framework` during your test target's
`Link Binary with Libraries` build phase. You should see two
`Quick.frameworks`; one is for OS X, and the other is for iOS.

![](http://cl.ly/image/2L0G0H1a173C/Screen%20Shot%202014-06-08%20at%204.27.48%20AM.png)

### 4. Start writing specs!

If you run into any problems, please file an issue.

## Who Uses Quick

- https://github.com/jspahrsummers/RXSwift

> Add an issue or [tweet](https://twitter.com/modocache) if you'd like to be added to this list.

## License

MIT license. See the `LICENSE` file for details.

