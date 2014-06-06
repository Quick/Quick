# Quick

A behavior-driven development framework for Swift. Inspired by
[RSpec](https://github.com/rspec/rspec), [Specta](https://github.com/specta/specta),
and [Ginkgo](https://github.com/onsi/ginkgo).

```swift
import XCTest

class PersonSpec: QuickSpec {
    override class func isConcreteSpec() -> Bool { return true }

    override class func exampleGroups() {
        describe("Person") {
            var person: Person?
            beforeEach { person = Person() }

            it("is happy") {
                XCTAssert(person!.isHappy,
                    "expected person to be happy by default")
            }

            describe("greeting") {
                context("when the person is unhappy") {
                    beforeEach { person!.isHappy = false }
                    it("is lukewarm") {
                        XCTAssertEqualObjects(person!.greeting, "Oh, hi.",
                            "expected a lukewarm greeting")
                    }
                }

                context("when the person is happy") {
                    beforeEach { person!.isHappy = true }
                    it("is enthusiastic") {
                        XCTAssertEqualObjects(person!.greeting, "Hello!",
                            "expected an enthusiastic greeting")
                    }
                }
            }
        }
    }
}
```

## Installation

This module is not yet fit for general consumption.
Still, if you want to test it out:

1. Clone the repository
2. Add the files in `QuickTests/Quick` to your test target
3. Set the `Objective-C Bridging Header` of your test target to
   `QuickTests/Quick/QuickTests-Bridging-Header.h`
4. Start writing specs!

## License

MIT license. See the `LICENSE` file for details.
