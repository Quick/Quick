# Quick

A behavior-driven development framework for Swift and Objective-C. Inspired by [RSpec](https://github.com/rspec/rspec), [Specta](https://github.com/specta/specta), and [Ginkgo](https://github.com/onsi/ginkgo).

![](http://f.cl.ly/items/1V40302G3w03263E2C0q/Screen%20Shot%202014-06-10%20at%2012.21.53%20AM.png)

## Syntax

Quick supports tests written in Swift:

```swift
// PersonSpec.swift

import Quick

class PersonSpec: QuickSpec {
    override func exampleGroups() {
        describe("a person") {
            var person: Person?
            beforeEach { person = Person() }

            it("is happy but never satisfied") {
                expect(person!.isHappy).to.beTrue()
                expect{person!.isSatisfied}.willNot.beTrue()
            }

            describe("greeting") {
                context("when the person is unhappy") {
                    beforeEach { person!.isHappy = false }
                    it("is lukewarm") {
                        expect(person!.greeting).to.equal("Oh, hi.")
                        expect(person!.greeting).notTo.equal("Hello!")
                    }
                }

                context("when the person is happy") {
                    beforeEach { person!.isHappy = true }
                    it("is enthusiastic") {
                        expect(person!.greeting).to.equal("Hello!")
                        expect(person!.greeting).notTo.equal("Oh, hi.")
                    }
                }
            }
        }
    }
}
```

...as well as specs written in Objective-C:

```objc
// PoetSpec.m

#import <Quick/Quick.h>

QuickSpecBegin(PoetSpec)

qck_describe(@"a poet", ^{
    __block Poet *poet = nil;
    qck_beforeEach(^{
        poet = [Poet new];
    });

    qck_context(@"when he/she is unhappy", ^{
        qck_it(@"is very dramatic", ^{
            XCTAssertEqualObjects(poet.greeting, @"Woe is me!",
                @"expected poet to be melodramatic");
        });
    });
});

QuickSpecEnd
```

## Expectations

> Currently Quick expectations are only available in Swift. See https://github.com/modocache/Quick/issues/26 for more details.

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

When passing an optional to an expectation there is no need to unwrap the
variable using a trailing `!`: Quick will do that for you.

```swift
var optVal: Int?

expect(optVal).to.beNil()

optVal = 123

expect(optVal).toNot.beNil()
expect(optVal).to.equal(123)
```

Quick also allows for asynchronous expectations, by wrapping the subject
in braces instead of parentheses. This allows the subject to be
evaluated as a closure. Below is an example of a subject who knows
only hunger, and never satisfaction:

```swift
expect{person!.isHungry}.will.beTrue()
expect{person!.isSatisfied}.willNot.beTrue()
```

Asynchronous expectations time out after one second by default. You can
extend this by using `willBefore`. The following times out after 3
seconds:

```swift
expect{person!.isHungry}.willBefore(3).beTrue()
expect{person!.isSatisfied}.willNotBefore(3).beTrue()
```

---

## Installation

> This module is beta software, and can only run using the latest, beta version
of Xcode.

To use Quick to test your iOS or OS X applications, follow these 4 easy steps:

1. [Clone the repository](https://github.com/modocache/Quick#1-clone-this-repository)
2. [Add `Quick.xcodeproj` to your test target](https://github.com/modocache/Quick#2-add-the-quickxcodeproj-file-to-your-applications-test-target)
3. [Link `Quick.framework` during your test target's `Link Binary with Libraries` build phase](https://github.com/modocache/Quick#3-link-the-quickframework)
4. Start writing specs!

An example project with this complete setup is available in the
[`Examples`](https://github.com/modocache/Quick/tree/master/Examples) directory.

#### 1. Clone this repository

```
git clone git@github.com:modocache/Quick.git
```

#### 2. Add the `Quick.xcodeproj` file to your application's test target

Right-click on the group containing your application's tests and
select `Add Files To YourApp...`.

![](http://cl.ly/image/3m110l2s0a18/Screen%20Shot%202014-06-08%20at%204.25.59%20AM.png)

Next, select `Quick.xcodeproj`, which you downloaded in step 1.

![](http://cl.ly/image/431F041z3g1P/Screen%20Shot%202014-06-08%20at%204.26.49%20AM.png)

Once you've added the Quick project, you should see it in Xcode's project
navigator, grouped with your tests.

![](http://cl.ly/image/0p0k2F2u2O3I/Screen%20Shot%202014-06-08%20at%204.27.29%20AM%20copy.png)

#### 3. Link the `Quick.framework`

Finally, link the `Quick.framework` during your test target's
`Link Binary with Libraries` build phase. You should see two
`Quick.frameworks`; one is for OS X, and the other is for iOS.

![](http://cl.ly/image/2L0G0H1a173C/Screen%20Shot%202014-06-08%20at%204.27.48%20AM.png)

#### 4. Start writing specs!

If you run into any problems, please file an issue.

## License

MIT license. See the `LICENSE` file for details.

