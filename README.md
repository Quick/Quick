![](http://f.cl.ly/items/2o2r3F1f3h3W1Y2E360J/Introducing-Quick.png)

Quick is a behavior-driven development framework for Swift and Objective-C.
Inspired by [RSpec](https://github.com/rspec/rspec), [Specta](https://github.com/specta/specta), and [Ginkgo](https://github.com/onsi/ginkgo).

![](http://f.cl.ly/items/2F362k2E3f0u2R0p3q1c/Screen%20Shot%202014-06-14%20at%208.16.22%20PM.png)

```swift
import Quick
import Nimble

class TableOfContentsSpec: QuickSpec {
    override func spec() {
        describe("the table of contents below") {
            it("has everything you need to get started") {
                let sections = TableOfContents().sections
                expect(sections).to.contain("Quick Core")
                expect(sections).to.contain("Quick Expectations")
                expect(sections).to.contain("How to Install Quick")
            }

            context("if it doesn't have what you're looking for") {
                it("needs to be updated") {
                    let you = You(awesome: true)
                    expect{you.submittedAnIssue}.will.beTrue()
                }
            }
        }
    }
}
```

# How to Use Quick

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Quick: Examples and Example Groups](#quick-examples-and-example-groups)
  - [Examples Using `it`](#examples-using-it)
  - [Example Groups Using `describe` and `context`](#example-groups-using-describe-and-context)
    - [Describing Classes and Methods Using `describe`](#describing-classes-and-methods-using-describe)
    - [Sharing Setup/Teardown Code Using `beforeEach` and `afterEach`](#sharing-setupteardown-code-using-beforeeach-and-aftereach)
    - [Specifying Conditional Behavior Using `context`](#specifying-conditional-behavior-using-context)
  - [Temporarily Disabling Examples or Groups Using `pending`](#temporarily-disabling-examples-or-groups-using-pending)
  - [Global Setup/Teardown Using `beforeSuite` and `afterSuite`](#global-setupteardown-using-beforesuite-and-aftersuite)
  - [Sharing Examples](#sharing-examples)
- [Nimble: Assertions Using `expect(...).to`](#nimble-assertions-using-expectto)
  - [Available Matchers](#available-matchers)
    - [Equal](#equal)
    - [BeIdenticalTo](#beidenticalto)
    - [BeNil](#benil)
    - [BeTrue](#betrue)
    - [BeFalse](#befalse)
    - [BeLessThan, BeLessThanOrEqualTo, BeGreaterThanOrEqualTo, BeGreaterThan](#belessthan-belessthanorequalto-begreaterthanorequalto-begreaterthan)
    - [Contain and BeEmpty](#contain-and-beempty)
    - [Raise](#raise)
  - [Automatic Optional Unwrapping](#automatic-optional-unwrapping)
  - [Asynchronous Expectations Using `will` and `willNot`](#asynchronous-expectations-using-will-and-willnot)
- [How to Install Quick](#how-to-install-quick)
  - [1. Clone this repository](#1-clone-this-repository)
  - [2. Add `Quick.xcodeproj` and `Nimble.xcodeproj` to your test target](#2-add-quickxcodeproj-and-nimblexcodeproj-to-your-test-target)
  - [3. Link `Quick.framework` and `Nimble.framework`](#3-link-quickframework-and-nimbleframework)
  - [4. Start writing specs!](#4-start-writing-specs!)
- [How to Install Quick File Templates](#how-to-install-quick-file-templates)
  - [Using Alcatraz](#using-alcatraz)
  - [Manually via the Rakefile](#manually-via-the-rakefile)
- [Who Uses Quick](#who-uses-quick)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Quick: Examples and Example Groups

Quick uses a special syntax that allows me to define **examples** and
**example groups**.

### Examples Using `it`

Examples use assertions to demonstrate how code should behave.
These are like "tests" in XCTest.

Quick allows me to define examples using `it`. `it` also takes a string,
which serves as a description of the example.

Below, I specify examples of how my `Dolphin` class should behave.
When I create a new dolphin, it should be smart and friendly.

```swift
// Swift

import Quick
import Nimble

class DolphinSpec: QuickSpec {
    override func spec() {
        it("is friendly") {
            expect(Dolphin().isFriendly).to.beTrue()
        }

        it("is smart") {
            expect(Dolphin().isSmart).to.beTrue()
        }
    }
}
```

```objc
// Objective-C

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

QuickSpecBegin(DolphinSpec)

qck_it(@"is friendly", ^{
    [nmb_expect(@([[Dolphin new] isFriendly])).to beTrue];
});

qck_it(@"is smart", ^{
    [nmb_expect(@([[Dolphin new] isSmart])).to beTrue];
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
method (or, in other words, I want to test the method works).

I can group all of the tests for `click` using `describe`. Grouping
similar examples together makes my spec easier to read.

```swift
// Swift

import Quick
import Nimble

class DolphinSpec: QuickSpec {
    override func spec() {
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
#import <Nimble/Nimble.h>

QuickSpecBegin(DolphinSpec)

qck_describe(@"a dolphin", ^{
    qck_describe(@"its click", ^{
        qck_it(@"is loud", ^{
            Click *click = [[Dolphin new] click];
            [nmb_expect(@(click.isLoud)).to beTrue];
        });

        qck_it(@"has a high frequency", ^{
            Click *click = [[Dolphin new] click];
            [nmb_expect(@(click.hasHighFrequency)).to beTrue];
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
import Nimble

class DolphinSpec: QuickSpec {
    override func spec() {
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
#import <Nimble/Nimble.h>

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
            [nmb_expect(@(click.isLoud)).to beTrue];
        });

        qck_it(@"has a high frequency", ^{
            [nmb_expect(@(click.hasHighFrequency)).to beTrue];
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
order to get a better idea of what it is.

I want to show that my `click` method behaves differently in different
circumstances. Normally, the dolphin just clicks once. But when the dolphin
is close to something interesting, it clicks several times.

I can express this in my tests by using `context`: one `context` for the
normal case, and one `context` for when the dolphin is close to
something interesting.

```swift
// Swift

import Quick
import Nimble

class DolphinSpec: QuickSpec {
    override func spec() {
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
#import <Nimble/Nimble.h>

QuickSpecBegin(DolphinSpec)

qck_describe(@"a dolphin", ^{
    __block Dolphin *dolphin = nil;
    qck_beforeEach(^{ dolphin = [Dolphin new]; });

    qck_describe(@"its click", ^{
        qck_context(@"when the dolphin is not near anything interesting", ^{
            qck_it(@"is only emitted once", ^{
                [nmb_expect(@([[dolphin click] count])).to nmb_equal:@1];
            });
        });

        qck_context(@"when the dolphin is near something interesting", ^{
            qck_beforeEach(^{
                [[Jamaica dolphinCove] add:[SunkenShip new]];
                [[Jamaica dolphinCove] add:dolphin];
            });

            qck_it(@"is emitted three times", ^{
                [nmb_expect(@([[dolphin click] count])).to nmb_equal:@3];
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
    override func spec() {
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

### Sharing Examples

I sometimes need to write one set of specifications, then apply those
specifications to several test objects.

For example, let's say I have a protocol called `Edible`. When a dolphin
eats something `Edible`, the dolphin becomes happy.

`Mackerel` and `Cod` are both edible, and I'd like to specify that
dolphins are happy to eat either one.

I can define a set of "shared examples" for "something edible". Then, I
can specify that both mackerel and cod behave like "something edible":

```swift
// Swift

import Quick
import Nimble

class EdibleSharedExamples: QuickSharedExampleGroups {
    override class func sharedExampleGroups() {
        sharedExamples("something edible") { (sharedExampleContext: SharedExampleContext) in
            it("makes dolphins happy") {
                let dolphin = Dolphin(happy: false)
                let edible = sharedExampleContext()["edible"]
                dolphin.eat(edible)
                expect(dolphin.isHappy).to.beTrue()
            }
        }
    }
}

class MackerelSpec: QuickSpec {
    override func spec() {
        var mackerel: Mackerel! = nil
        beforeEach {
            mackerel = Mackerel()
        }

        itBehavesLike("something edible") { ["edible": mackerel] }
    }
}

class CodSpec: QuickSpec {
    override func spec() {
        var cod: Cod! = nil
        beforeEach {
            cod = Cod()
        }

        itBehavesLike("something edible") { ["edible": cod] }
    }
}
```

Shared examples can include any number of `it`, `context`, and
`describe` blocks. They save me a *lot* of typing when I want to run
the same tests against several different kinds of objects.

If I don't need any additional context, I can simply use closures that
take no parameters. This might be useful when testing some sort of
global state:

```swift
// Swift

import Quick

sharedExamplesFor("everything under the sea") {
    // ...
}

itBehavesLike("everything under the sea")
```

## Nimble: Assertions Using `expect(...).to`

I can use Quick to define examples and example groups. Within those
examples, I can make expectations using Nimble, Quick's sister project.

Nimble expectations use the `expect(...).to` syntax:

```swift
// Swift

import Nimble

expect(person.greeting).to.equal("Oh, hi.")
expect(person.greeting).notTo.equal("Hello!")
```

```objc
// Objective-C

#import <Nimble/Nimble.h>

[nmb_expect(person.greeting).to nmb_equal:@"Oh, hi."];
[nmb_expect(person.greeting).notTo nmb_equal:@"Hello!"];
```

### Available Matchers

Nimble includes matchers that test whether the subject of an
expectation is true, or equal to something, or whether it
contains a specific element:

```swift
// Swift

import Nimble

expect(person.isHappy).to.beTrue()
expect(person.greeting).to.equal("Hello!")
expect(person.hopes).to.contain("winning the lottery")
```

```objc
// Objective-C

#import <Nimble/Nimble.h>

[nmb_expect(@(person.isHappy)).to beTrue];
[nmb_expect(person.greeting).to nmb_equal:@"Hello!"];
[nmb_expect(person.hopes).to nmb_contain:@"winning the lottery"];
```

#### Equal

`Equal` matches if two objects are equal. It tests for equality using
the `==` operator:

```swift
expect("dolphin").to.equal("dolphin")
expect("dolphin").toNot.equal("sea turtle")
```

```objc
[nmb_expect(@"dolphin").to nmb_equal:@"dolphin"];
[nmb_expect(@"dolphin").toNot nmb_equal:@"sea turtle"];
```

#### BeIdenticalTo

`BeIdenticalTo` matches if two objects are the *same object*. It tests for
identity using the `===` operator:

```swift
let kind = "bottlenose dolphins"
expect(kind).to.beIdenticalTo(kind)
expect(kind).toNot.beIdenticalTo("bottlenose dolphins")
```

```objc
NSString *kind = @"bottlenose dolphins"
[nmb_expect(kind).to nmb_beIdenticalTo:kind];
[nmb_expect(kind).toNot nmb_beIdenticalTo:@"bottlenose dolphins"];
```

Note that in the above example, `beIdenticalTo()` matches when comparing
the same string object (`kind`), but doesn't match for two different string
objects--even though the strings themselves are equal.

#### BeNil

`BeNil` acts just like the `Equal` matcher, but it tests whether the
subject of the expectation is equal to `nil`:

```swift
expect(nil).to.beNil()
expect("dolphin").toNot.beNil()
```

```objc
[nmb_expect(nil).to beNil];
[nmb_expect(@"dolphin").toNot beNil];
```

#### BeTrue

`BeTrue` matches if the subject of the expectation is equal to `true`:

```swift
expect(true).to.beTrue()
expect(false).toNot.beTrue()
expect(10).toNot.beTrue()
```

```objc
[nmb_expect(@YES).to beTrue];
[nmb_expect(@NO).toNot beTrue];
[nmb_expect(@10).to beTrue];
```

Note that although `10` above is a "truthy" value, it is not equal to
the boolean `true`, so `beTrue()` does not match.

> **NOTE:** In Objective-C, `@1` and `@YES` are equal, so the expectation
  `[nmb_expect(@1).to beTrue]` passes.

#### BeFalse

Similarly to `BeTrue`, `BeFalse` matches if the subject of the
expectation is equal to `false`:

```swift
expect(false).to.beFalse()
expect(true).toNot.beFalse()
expect(nil).toNot.beFalse)
```

```objc
[nmb_expect(@NO).to beFalse];
[nmb_expect(@YES).toNot beFalse];
[nmb_expect(nil).toNot beFalse];
```

#### BeLessThan, BeLessThanOrEqualTo, BeGreaterThanOrEqualTo, BeGreaterThan

These matchers compare the subject to arbitrary numbers. They only match
if both the subject and the given value are numbers, and those
numbers meet the given conditions:

```swift
expect(10).to.beLessThan(11)
expect(10).to.beLessThanOrEqualTo(10)
expect(10).to.beGreaterThanOrEqualTo(10)
expect(10).to.beGreaterThan(9)
```

```objc
[nmb_expect(@10).to nmb_beLessThan(@11)];
[nmb_expect(@10).to nmb_beLessThanOrEqualTo(@10)];
[nmb_expect(@10).to nmb_beGreaterThanOrEqualTo(@10)];
[nmb_expect(@10).to nmb_beGreaterThan(@9)];
```

#### Contain and BeEmpty

These matchers apply to collections such as arrays or sets. `Contain`
matches if the array or set contains the specified element:

```swift
expect([1, 2, 3]).to.contain(1)
expect([1, 2, 3]).toNot.contain(4)
```

```objc
[nmb_expect((@[@1, @2, @3])).to nmb_contain:@1];
[nmb_expect((@[@1, @2, @3])).to nmb_contain:@4];
```

`Contain` can also be used on strings. It matches if the string contains
the given substring:

```swift
expect("blowfish").to.contain("fish")
expect("dolphin").toNot.contain("fish")
```

```objc
[nmb_expect(@"blowfish").to nmb_contain:@"fish"];
[nmb_expect(@"dolphin").to nmb_contain:@"fish"];
```

`BeEmpty` matches if the given array or set contains no elements, or if
the given string is an empty string (`""`):

```swift
expect([]).to.beEmpty()
expect([1, 2, 3]).toNot.beEmpty()
expect("").to.beEmpty()
```

```objc
[nmb_expect((@[])).to beEmpty];
[nmb_expect((@[@1, @2, @3])).toNot beEmpty];
[nmb_expect(@"").to beEmpty];
```

#### Raise

Quick also allows me to make expectations on closures. For example, I
can specify that a block of code raises an exception. I can also specify
it raises an exception with a specific name, reason, or userInfo
dictionary:

```swift
expect{penguin.fly()}.to.raise()
expect{penguin.fly()}.to.raise(NSInternalInconsistencyException)
expect{penguin.fly()}.to.raise(NSInternalInconsistencyException, reason: "Penguins can't fly!")
expect{penguin.fly()}.to.raise(NSInternalInconsistencyException, reason: "Penguins can't fly!", userInfo: ["url": "https://www.youtube.com/watch?v=6JsZbSzMi08"])
```

```objc
[nmb_expect([penguin fly]).to nmb_raise];
[nmb_expect([penguin fly]).to nmb_raiseWithName:NSInternalInconsistencyException];
[nmb_expect([penguin fly]).to nmb_raiseWithName:NSInternalInconsistencyException
                                         reason:@"Penguins can't fly!"];
[nmb_expect([penguin fly]).to nmb_raiseWithName:NSInternalInconsistencyException
                                         reason:@"Penguins can't fly!"
                                       userInfo:@{@"url": @"https://www.youtube.com/watch?v=6JsZbSzMi08"}];
```

### Automatic Optional Unwrapping

When passing an optional to an expectation in Swift, there's no need to
unwrap the variable using a trailing `!`: Nimble does that for me.

```swift
var optVal: Int?

expect(optVal).to.beNil()

optVal = 123

expect(optVal).toNot.beNil()
expect(optVal).to.equal(123)
```

### Asynchronous Expectations Using `will` and `willNot`

Nimble also allows for asynchronous expectations, by wrapping the subject
in braces instead of parentheses. This allows the subject to be
evaluated as a closure. Below is an example of a subject who knows
only hunger, and never satisfaction:

```swift
// Swift

import Nimble

expect{person.isHungry}.will.beTrue()
expect{person.isSatisfied}.willNot.beTrue()
```

```objc
// Objective-C

#import <Nimble/Nimble.h>

[nmb_expectBlock(^{ return @(person.isHungry); }).will beTrue];
[nmb_expectBlock(^{ return @(person.isSatisfied); }).willNot beTrue];
```

Asynchronous expectations time out after one second by default. I can
extend this default by using `willBefore`. The following times out after 3
seconds:

```swift
// Swift

import Nimble

expect{person!.isHungry}.willBefore(3).beTrue()
expect{person!.isSatisfied}.willNotBefore(3).beTrue()
```

```objc
// Objective-C

#import <Nimble/Nimble.h>

[[nmb_expectBlock(^{ return @(person.isHungry); }) willBefore:3] beTrue];
[[nmb_expectBlock(^{ return @(person.isSatisfied); }) willNotBefore:3] beTrue];
```

## How to Install Quick

> This module is beta software, and can only run using the latest, beta version
of Xcode.

Quick provides the syntax to define examples and example groups. Nimble
provides the `expect(...).to` assertion syntax. You may either one, or
both, in your tests.

To use Quick and Nimble to test your iOS or OS X applications, follow these 4 easy steps:

1. [Clone the repository](#1-clone-this-repository)
2. [Add `Quick.xcodeproj` and `Nimble.xcodeproj` to your test target](#2-add-quickxcodeproj-and-nimblexcodeproj-to-your-test-target)
3. [Link `Quick.framework` and `Nimble.framework`](#3-link-quickframework-and-nimbleframework)
4. Start writing specs!

An example project with this complete setup is available in the
[`Examples`](https://github.com/modocache/Quick/tree/master/Examples) directory.

### 1. Clone this repository

```
git clone git@github.com:modocache/Quick.git
```

### 2. Add `Quick.xcodeproj` and `Nimble.xcodeproj` to your test target

Right-click on the group containing your application's tests and
select `Add Files To YourApp...`.

![](http://cl.ly/image/3m110l2s0a18/Screen%20Shot%202014-06-08%20at%204.25.59%20AM.png)

Next, select `Quick.xcodeproj`, which you downloaded in step 1.

![](http://cl.ly/image/431F041z3g1P/Screen%20Shot%202014-06-08%20at%204.26.49%20AM.png)

Once you've added the Quick project, you should see it in Xcode's project
navigator, grouped with your tests.

![](http://cl.ly/image/0p0k2F2u2O3I/Screen%20Shot%202014-06-08%20at%204.27.29%20AM%20copy.png)

Follow the same steps for `Nimble.xcodeproj`.

### 3. Link `Quick.framework` and `Nimble.framework`

 Link the `Quick.framework` during your test target's
`Link Binary with Libraries` build phase. You should see two
`Quick.frameworks`; one is for OS X, and the other is for iOS.

![](http://cl.ly/image/2L0G0H1a173C/Screen%20Shot%202014-06-08%20at%204.27.48%20AM.png)

Do the same for the `Nimble.framework`.

### 4. Start writing specs!

If you run into any problems, please file an issue.

## How to Install Quick File Templates

The Quick repository includes file templates for both Swift and
Objective-C specs.

### Using Alcatraz

Quick templates can be installed via [Alcatraz](https://github.com/supermarin/Alcatraz),
a package manager for Xcode. Just search for the templates from the
Package Manager window.

![](http://f.cl.ly/items/3T3q0G1j0b2t1V0M0T04/Screen%20Shot%202014-06-27%20at%202.01.10%20PM.png)

### Manually via the Rakefile

To manually install the templates, just clone the repository and
run the `templates:install` rake task:

```sh
$ git clone git@github.com:modocache/Quick.git
$ rake templates:install
```

Uninstalling is easy, too:

```sh
$ rake templates:uninstall
```

## Who Uses Quick

- https://github.com/jspahrsummers/RXSwift

> Add an issue or [tweet](https://twitter.com/modocache) if you'd like to be added to this list.

## License

MIT license. See the `LICENSE` file for details.

