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

> This module is beta software, and can only run using the latest, beta version
of Xcode.

### OS X

To use Quick to test your OS X applications, follow these 4 easy steps.

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
`Link Binary with Libraries` build phase.

![](http://cl.ly/image/2L0G0H1a173C/Screen%20Shot%202014-06-08%20at%204.27.48%20AM.png)

#### 4. Start writing specs!

If you run into any problems, please file an issue.

### iOS

Detailed instructions coming soon. Pull requests welcome.

## License

MIT license. See the `LICENSE` file for details.
