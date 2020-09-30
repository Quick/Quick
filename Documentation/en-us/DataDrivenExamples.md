# Iterate example specifications over a set of data

Sometimes you will find yourself writing unit tests that repeats almost exactly
the same specification code over and over again. Typically this happens when you
have a function, class or struct you want to test for different combinations of
input data and output data.

Instead of repeating almost the exact same code over and over again, you can define
the data as a set and iterate your test specification.

## Tests for a list of input and outputs

The following is an basic example to illustrate the concept, where we want to test
the function `double` for a list of input/output combinations:

The source code defining the `double`-function
```swift
/* The function we want to test*/
func double(_ value : Int) -> Int { return 2*value }
```

The test code defining the data driven specification:
```swift
import Quick
import Nimble

class DoubleFunctionTests: QuickSpec {
    override func spec() {
        describe("the double function") {
            let dataSet : [(input: Int, output: Int)] = [
                (input: 0, output: 0),
                (input: 1, output: 2),
                (input: 2, output: 4)
            ]
            dataSet.forEach { (input: Int, output: Int) in
                context("for input \(input)") {
                    it("should return \(output)") {
                        expect(double(input)).to(equal(output))
                    }
                }
            }
        }
    }
}
```
## Make xcode trace failures to the line of the data example

If you want you can extend the testcode to make xcode mark failing tests at the line
where the data input/output was specified instead of the `expect`that failed. Notice
that the default value in the init function for TestData takes care of recording the
line number for each data line using the `#line` macro.

```swift
import Quick
import Nimble

class TestData<T> {
    public let input: T
    public let output: T
    public let line: UInt

    init(input: T, output: T, line: UInt = #line) {
        self.input = input
        self.output = output
        self.line = line
    }
}

class QuickDataDrivenTests: QuickSpec {
    override func spec() {
        describe("the double function") {
            let dataSet = [
                TestData<Int>(input: 0, output: 0),
                TestData<Int>(input: 1, output: 2),
                TestData<Int>(input: 2, output: 4)
            ]
            dataSet.forEach { (data) in
                context("for input \(self.input)") {
                    it("should return \(output)", line: data.line) {
                        expect(double(input), line: data.line).to(equal(data.output))
                    }
                }
            }
        }
    }
}
```
## More dimensions and complex test data

Should there be multiple aspects or combinations of input to test or results that
could be multi-dimensional, you can of course extend the tests to suit that.

Here is an example where a class, `WeirdClass` should be created from a string,
`init(String)`, and have two different derived properties, `weirdness` and `firstThree`.

*Note that the tracing of line numbers is left out in this example for conciseness.*

```swift
import Quick
import Nimble

class WeirdClassTests: QuickSpec {
    override func spec() {
        describe("the WeirdClass") {
            let dataSet : [(input: String, firstThree: String, weirdness: Int)] = [
                (input: "foobar", firstThree: "foo", weirdness: 35),
                (input: "Hello world", firstThree: "Hel", weirdness: 524),
                (input: "78ghkajsdf", firstThree: "78g", weirdness: 1240),
            ]
            dataSet.forEach { (input: String, firstThree: String, weirdness: Int) in
                context("for input \(input)") {
                    var weird : WeirdClass!
                    beforeEach {
                      weird = WeirdClass(input)
                    }
                    it("should have weirdness \(output)") {
                      expect(weird.weirdness).to(equal(weirdness))
                    }
                    it("shoud have first three \(firstThree)") {
                      expect(weird.firstThree).to(equal(firstThree)
                    }
                }
            }
        }
    }
}
```

## Further reducing the boilerplate
Define a little generic helper function called `given` like this:

```swift
/**
 Used to iterate through a set of given data. This can then be used to provide multiple examples of data.
- Parameter input: The list of data to iterate through.
- Parameter then: The closure to execute each item on.
 */
func given<Input>(_ input: Input..., then: (_: Input) -> Void) {
    for i in input { then(i) }
}
```
With that function you can write your specification like:
```swift
given(
    (1, plus: 1, is: 2),
    (1, plus: 2, is: 2),
    (1, plus: 3, is: 4)
) { (a, b, result) in
    it("\(a) plus \(b) is \(result)") {
        expect(a + b).to(equal(result))
    }
}
```
### Tracing the line on errors
Should you want xcode to trace the line when tests fail, you can add this, like so:

```swift
given(
    (1, plus: 1, is: 2, line: #line),
    (1, plus: 2, is: 2, line: #line),
    (1, plus: 3, is: 4, line: #line)
) { (a, b, result, line: UInt) in
    it("\(a) plus \(b) is \(result)") {
        expect(line: line, a + b).to(equal(result))
    }
}
```


## Pitfalls

There are some pitfalls, that might cause you some grief.

### Duplicate test names.

Remember to use the test data to make the strings in the `context`, and `it` unique.
For example by using the Swift string interpolation like:

```swift
context("for input \(input)” {
  it("should return \(output)") {
    /* expect(...) */
  }
}
```

### Tests are not discovered

It seems that the `forEach` block must have the tests in at least one `context` to
be discovered and later executed.
