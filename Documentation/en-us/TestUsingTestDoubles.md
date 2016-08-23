# Testing with Mock

## Test doubles

The following problem comes up often when writing tests. Here, `Car` Class uses(depends on) `Tire` Class.

![](https://github.com/Quick/Assets/blob/master/Screenshots/TestUsingMock_BusesA.png)

Here's one example: CarTests test `Car`, which uses `Tire`. Now bugs in `Tire` cause CarTests to fail, even though `Car` is fine!
All the failures are confusing--it's hard to answer the question "what's broken?"

To avoid this problem, we can use a stand-in for `Tire` in Cartests. In this case, we call stand-in for Tire `PerfectTire class`.

![](https://github.com/Quick/Assets/blob/master/Screenshots/TestUsingMock_BusesAmock.png)

`PerfectTire class` has same methods and properties as `A Class` (although its implementation of thos methods and properties might be different). So we can replace `Tire` class with `PerfectTire` class in CarTests.

Objects like `PerfectTire` class are called 'test doubles'. 'test doubles' are used as stand-in for tests.
There are several kinds of 'test doubles'.

- Mock object: used for receiving output from test class
- Stub object: used for providing input to test class
- Fake object: behaves similar as original class

Here, we explain using `Mock` next section.

## Mock

A mock is a class or struct used for verifying test objects work with other objects from point of view of test target's output.

### Writing test with Mock in Swift

#### Sample app

For example, we show an app which retrieves data from internet.

* Display data from internet in ArticleViewController
* Custom class implements DataProviderProtocol is responsible for getting data.

DataProviderProtocol is defined as follows,

```swift
// Swift
protocol DataProviderProtocol: class {
    func fetch(callback: (data: String) -> Void)
}
```
`fetch()` gets data from internet and output data with callback block.

Here's DataProvider which implements DataProviderProtocol.

```swift
// Swift
class DataProvider: NSObject, DataProviderProtocol {
    func fetch(callback: (data: String) -> Void) {
        let url = NSURL(string: "http://example.com/")!
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithURL(url, completionHandler: {
            (data, resp, err) in
            let string = NSString(data:data!, encoding:NSUTF8StringEncoding) as! String
            callback(data: string)
        })
        task.resume()
    }
}
```
In our scenario, `fetch()` is called in `viewDidLoad()` of ViewController.

Code is below.

```swift
// Swift
class ViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    private var dataProvider: DataProviderProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        dataProvider = dataProvider ?? DataProvider()

        dataProvider?.fetch({ [unowned self] (data) -> Void in
            self.resultLabel.text = data
        })
    }
}
```

#### Writing test with Mock of DataProviderProtocol

ArticleViewController depends on DataProviderProtocol.
Here, create Mock which inherits DataProviderProtocol in Test Targets in order to test ViewController.

If you create mocks, you can,
- run much faster.
- run correctly whether you're connected to the Internet or not.
- focus on testing ViewController. (Test will not fail because of errors in your actual DataProvider).

```swift
// Swift
class MockDataProvider: NSObject, DataProviderProtocol {
    var fetchCalled = false
    func fetch(callback: (data: String) -> Void) {
        fetchCalled = true
        callback(data: "foobar")
    }
}
```

`fetchCalled` property is deinfed in Mock. `fetchCalled` is set to `true` when `fetch()` called.
Ready to run test!

This test verifies that `When ViewController is loaded, ViewController calls dataProvider.fetch()`.

```swift
// Swift
override func spec() {
    describe("view controller") {
        it("fetch data with data provider") {
            let mockProvier = MockDataProvider()
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            viewController.dataProvier = mockProvier

            expect(mockProvier.fetchCalled).to(equal(false))

            let _ = viewController.view

            expect(mockProvier.fetchCalled).to(equal(true))
        }
    }
}
```

Mock makes us easy to verify behavior which works with other objects.

For more details about writing test, see https://realm.io/news/testing-in-swift/ .
