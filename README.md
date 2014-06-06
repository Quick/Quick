# Quick

A behavior-driven development framework for Swift. Inspired by
[RSpec](https://github.com/rspec/rspec), [Specta](https://github.com/specta/specta),
and [Ginkgo](https://github.com/onsi/ginkgo).

```swift
class PersonSpec: QuickSpec {
    override class func isConcreteSpec() -> Bool { return true }

    override class func exampleGroups() {
        describe("Person") {
            var person: Person?
            beforeEach { person = Person() }

            it("is happy") {
                expect(person!.isHappy).to.beTrue()
            }

            it("is a dreamer") {
                expect(person!.hopes).to.contain("winning the lottery")
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

## Installation

This module is not yet fit for general consumption.
Still, if you want to test it out:

1. Clone the repository
2. Add the files in `QuickTests/Quick` to your test target
3. Set the `Objective-C Bridging Header` of your test target to
   `QuickTests/Quick/Quick-Bridging-Header.h`
4. Start writing specs!

## License

MIT license. See the `LICENSE` file for details.
