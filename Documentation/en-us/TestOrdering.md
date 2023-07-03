# Test Ordering

By default, Quick will suggest that XCTest runs tests in a `QuickSpec` or
`AsyncSpec` in the order they are defined in. This can be easily overriden by
specifying the "Randomize Execution Order" option in your testplan.
Additionally, we have found that doing any kind of filtering, such as selecting
a test gem, will also override this suggestion.

However, if you run all tests at once (via `xcodebuild test`, product -> Test,
or `swift test`), then XCTest should run tests in the order as specified. For
example, with the following tests:


```swift
describe("A describe block") {
    it("runs this test first every time") {}
    it("runs this test second every time") {}
}

context("A context block") {
    it("runs this test third every time") {}
    it("runs this test fourth every time") {}
}
```

Quick will try to run them in the order as:

- `A describe block, runs this test first every time`
- `A describe block, runs this test second every time`
- `A context block, runs this test third every time`
- `A context block, runs this test fourth every time`.

Using the `.defined` switch on the `order` parameter of a `describe` or
`context` block will ensure Quick runs the tests within this block in the
order they are defined.

That said, despite this attempt to suggest ordering, we strongly suggest that
you enable XCTest's "Randomize Execution Order". Good, robust unit testing
suites avoid imposing ordering on tests as much as possible.

## Nested `describe` and `context` blocks

How does this all work for deeply nested tests with many layers of `describe`
and `context` blocks? Let's look at some examples:

```swift
// 1
describe("Top level is defined") {
    it("runs this test first every time") {}

    // 2
    context("Nested context with defined order") {
        it("runs this test second every time") {}
        it("runs this test third every time") {}
    }

    it("runs this test fourth every time") {}
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

## Why specify an order if random ordering is recommended?

This is done primarily to maintain expectations with how XCTest tests are run.
This ordering of tests is how most people expect Quick tests to run, and by
using the "Randomize Execution Order" option of test plans, we are also
maintaining compatibility with XCTest-based tests you may have.
