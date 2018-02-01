# Test Ordering

Quick provides a way to enforce ordering on your project's tests. The API for
this acts on the level of `describe` and `context` blocks, and provides
two options:
- `.defined` - Guarantees that your tests will run in the order that they appear
in the test itself with every test run. This is the default value.
- `.random` - Randomizes the order that tests run within that block.

For more details about each of these settings, including examples, read on.

## `.defined` Test Order

_Example_
```swift
describe("A describe block of ordered tests", order: Order.defined) {
    it("runs this test first every time") {}
    it("runs this test second every time") {}
}

context("A context block of ordered tests", order: Order.defined) {
    it("runs this test first every time") {}
    it("runs this test second every time") {}
}
```

Using the `.defined` switch on the `order` parameter of a `describe` or
`context` block will ensure Quick runs the tests within this block in the
order they are defined.

## `.random` Test Order

_Example_
```swift
describe("A describe block of ordered tests", order: Order.random) {
    it("could run first or second") {}
    it("could run first or second") {}
}

context("A context block of ordered tests", order: Order.random) {
    it("could run first or second") {}
    it("could run first or second") {}
}
```

Using the `.random` switch on the `order` parameter of a `describe` or
`context` block will cause Quick to randomize the order in which these tests
are run.

We recommend that you use this option. Good, robust unit testing suites avoid
imposing ordering on tests as much as possible.

## Nested `describe` and `context` blocks

How does this all work for deeply nested tests with many layers of `describe`
and `context` blocks? Let's look at some examples:

```swift
// 1
describe("Top level is defined", order: Order.defined) {
    it("runs this test first every time") {}

    // 2
    context("Nested context with defined order", order: Order.defined) {
        it("runs this test second every time") {}
        it("runs this test third every time") {}
    }

    it("runs this test fourth every time") {}

    // 3
    describe("Nested describe with random order", order: Order.random) {
        it("runs this test fifth or sixth every time") {}
        it("runs this test fifth or sixth every time (whichever first isn't)") {}
    }
}
```

- At `1`, we have defined a `describe` block with `.defined`. It will thus order
all Quick "elements" inside (`it`s, `describe`s, and `context`s) in the
sequence they appear within the block.
- At `2`, we've defined a `context` block with `.defined`. It will runs its
Quick elements in the order they appear in the block, just as is happening with
the `describe` block defined at `1`. Note that when this `context` gets "its
 turn" in the order, it will run through all the elements it has inside.

 All the above would apply if the block were a `describe` instead.
- At `3`, we've defined a `describe` block with `.random`. It will run its
Quick elements in a random order. However, because this `describe` falls within
a `describe` block with `.defined` order, the randomness is limited within the
grand scheme of the test suite. In other words, the `.random` switch only
randomizes the tests within the nested `describe`, and because that `describe`
appears at "slot" 5 within the top-level `describe`, that means that the
shuffling of the inner `it` blocks only shuffles the tests within slot 5 and
slot 6.

 All the above would apply if the block were a `context` instead.

## Why default to `.defined` if `.random` is recommended?

This is done primarily to avoid breaking existing Quick test suites, as the
behavior of `.defined` most closely matches the way that it worked before the
addition of this feature.
