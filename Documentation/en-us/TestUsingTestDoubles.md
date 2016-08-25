# Testing with Mock

## Test doubles

The following problem occurs frequently when writing tests. In example, `Car` depends on/uses `Tire`.

![](https://github.com/Quick/Assets/blob/master/Screenshots/TestUsingMock_BusesA.png)

`CarTests` test `Car` which calls `Tire`. Now bugs in `Tire` could cause `CarTests` to fail (even though `Car` is okay).

It can be hard to answer the question: "What's broken?". To avoid this problem, one can use a stand-in object for `Tire` in `CarTests`. In this case, we'll create a stand-in object for `Tire` called `PerfectTire`.

![](https://github.com/Quick/Assets/blob/master/Screenshots/TestUsingMock_BusesAmock.png)

`PerfectTire` would have all of the same functions and properties as `Tire`. However, the implementation of those functions and properties may differ.

Objects like `PerfectTire` are called "test doubles". Test doubles are used as "stand-in objects" for testing functionality of related objects in isolation. There are several kinds of test doubles:

- Mock object: Used for receiving output from a test class.
- Stub object: Used for providing input to a test class.
- Fake object: Behaves similar to the original class.

Let's start with how to use mock objects.

## Mock

A mock object focuses on fully specifying what the correct interaction is supposed to be with other objects and detecting when something goes awry. The mock object should know (in advance) what is supposed to happen during the test and how the mock object is supposed to react.

### Writing test with Mock in Swift

#### Sample app

For example, we will provide an app which retrieves data from the internet.

* Displays the data from the internet in `ViewController`.
* Custom class implements `DataProviderProtocol`, which is responsible for fetching data.

`DataProviderProtocol` is defined as follows:

```swift
protocol DataProviderProtocol: class {
    func fetch(callback: (data: String) -> Void)
}
```

`fetch()` gets data from the internet and returns it using a `callback` closure.

Here is `DataProvider` which implements the `DataProviderProtocol` protocol.

```swift
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

In our scenario, `fetch()` is called in `viewDidLoad()` of `ViewController`.

```swift
class ViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var resultLabel: UILabel!
    private var dataProvider: DataProviderProtocol?

    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        dataProvider = dataProvider ?? DataProvider()

        dataProvider?.fetch({ [unowned self] (data) -> Void in
            self.resultLabel.text = data
        })
    }
}
```

#### Testing using a Mock of `DataProviderProtocol`

`ViewController` depends on `DataProviderProtocol`. Create a mock object which conforms to `DataProviderProtocol` in order to test the view controller.

Mock objects are great because you can:

- Run tests a lot quicker.
- Run tests even if you're not connected to the internet.
- Focus on testing `ViewController` in isolation.

```swift
class MockDataProvider: NSObject, DataProviderProtocol {
    var fetchCalled = false
    func fetch(callback: (data: String) -> Void) {
        fetchCalled = true
        callback(data: "foobar")
    }
}
```

The `fetchCalled` property is set to `true` when `fetch()` is called. This helps the test determine if the object is ready to test.

The following test verifies that when `ViewController` is loaded, the view controller should call `dataProvider.fetch()`.

```swift
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

If you're interested in learning more about writing tests, continue on to https://realm.io/news/testing-in-swift/.
