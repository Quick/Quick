# Testing with Mocks

## Test doubles

Dependencies between objects can cause problems when writing tests. For example, say you have a `Car` class that depends on/uses `Tire`.

![](https://github.com/Quick/Assets/blob/master/Screenshots/TestUsingMock_BusesA.png)

`CarTests` tests `Car`, which calls `Tire`. Now bugs in `Tire` could cause `CarTests` to fail (even though `Car` is okay). It can be hard to answer the question: "What's broken?".

To avoid this problem, you can use a stand-in object for `Tire` in `CarTests`. In this case, we'll create a stand-in object for `Tire` called `PerfectTire`.

![](https://github.com/Quick/Assets/blob/master/Screenshots/TestUsingMock_BusesAmock.png)

`PerfectTire` will have all of the same public functions and properties as `Tire`. However, the implementation of some or all of those functions and properties will differ.

Objects like `PerfectTire` are called "test doubles". Test doubles are used as "stand-in objects" for testing the functionality of related objects in isolation. There are several kinds of test doubles:

- Mock object: Used for receiving output from a test class.
- Stub object: Used for providing input to a test class.
- Fake object: Behaves similarly to the original class, but in a simplified way.

Let's start with how to use mock objects.

## Mock

A mock object focuses on fully specifying the correct interaction with other objects and detecting when something goes awry. The mock object should know (in advance) the methods that should be called on it during the test and what values the mock object should return.

Mock objects are great because you can:

- Run tests a lot quicker.
- Run tests even if you're not connected to the Internet.
- Focus on testing classes in isolation from their dependencies.

### Writing Tests with Mock Objects in Swift

#### Sample app

For example, let's create an app which retrieves data from the Internet:

* Data from the Internet will be displayed in `ViewController`.
* A custom class will implement the `DataProviderProtocol`, which specifies methods for fetching data.

`DataProviderProtocol` is defined as follows:

```swift
protocol DataProviderProtocol: class {
    func fetch(callback: @escaping (data: String) -> Void)
}
```

`fetch()` gets data from the Internet and returns it using a `callback` closure.

Here is the `DataProvider` class, which conforms to the `DataProviderProtocol` protocol.

```swift
class DataProvider: NSObject, DataProviderProtocol {
    func fetch(callback: @escaping (data: String) -> Void) {
        let url = URL(string: "http://example.com/")!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) {
            (data, resp, err) in
            let string = String(data: data!, encoding: .utf8)
            callback(data: string)
        }
        task.resume()
    }
}
```

In our scenario, `fetch()` is called in the `viewDidLoad()` method of `ViewController`.

```swift
class ViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var resultLabel: UILabel!
    private var dataProvider: DataProviderProtocol?

    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let dataProvider = dataProvider ?? DataProvider()

        dataProvider.fetch({ [weak self] (data) -> Void in
            self?.resultLabel.text = data
        })
    }
}
```

#### Testing using a Mock of `DataProviderProtocol`

`ViewController` depends on `DataProviderProtocol`. In order to test the view controller in isolation, you can create a mock object which conforms to `DataProviderProtocol`.

```swift
class MockDataProvider: NSObject, DataProviderProtocol {
    var fetchCalled = false
    func fetch(callback: @escaping (data: String) -> Void) {
        fetchCalled = true
        callback(data: "foobar")
    }
}
```

The `fetchCalled` property is set to `true` when `fetch()` is called, so that the test can confirm that it was called.

The following test verifies that when `ViewController` is loaded, the view controller calls `dataProvider.fetch()`.

```swift
final class ViewControllerSpec: QuickSpec {
    override class func spec() {
        describe("view controller") {
            it("fetches data with the data provider") {
                let mockProvider = MockDataProvider()
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ViewController") as! ViewController
                viewController.dataProvider = mockProvider

                expect(mockProvider.fetchCalled).to(beFalse())

                _ = viewController.view

                expect(mockProvider.fetchCalled).to(beTrue())
            }
        }
    }
}
```

##### Handling Different Errors in Callbacks

What if DataProvider could fail and throw an error? This is easy to handle. The
easiest way to handle that is to have `DataProviderProtocol.fetch(callback:)`'s
callback take in a `Result<String, Error>`, instead of a `String`. Like so:

```swift
protocol DataProviderProtocol: class {
    func fetch(callback: @escaping (Result<String, Error>) -> Void)
}
```

This is also commonly expressed by having the callback take in `(data: String?, error: Error?)`
arguments, which can express the same thing.

Of course, with the updated `DataProviderProtocol`, we have to update our `DataProvider`:

```swift
class DataProvider: NSObject, DataProviderProtocol {
    func fetch(callback: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "http://example.com/")!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) {
            (data, resp, err) in
            if let data {
                let string = String(data: data, encoding: .utf8)!
                callback(.success(string))
            } else {
                callback(.failure(err!)
            }
        }
        task.resume()
    }
}
```

Then, of course, our View Controller will need to be updated to deal with the
fact that `DataProvider` can return an error:

```swift
class ViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var resultLabel: UILabel!
    private var dataProvider: DataProviderProtocol?

    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let dataProvider = dataProvider ?? DataProvider()

        dataProvider.fetch({ [weak self] (result) -> Void in
            switch result {
            case .success(let data):
                self?.resultLabel.text = data
            case .failure(let error):
                self?.resultLabel.text = "Error, try again"
            }
        })
    }
}
```

And then, we will update `MockDataProvider`. In this case, we will be changing
`MockDataProvider` so that it doesn't immediately call the callback. This allows
us to test the intermediate state in the code (before the callback has resolved),
as well as both the success and failure cases.

```swift
class MockDataProvider: NSObject, DataProviderProtocol {
    var fetchCalled: Bool { !fetchCalls.isEmpty }
    private(set) var fetchCalls = [(Result<String, Error>) -> Void) = []
    func fetch(callback: @escaping (Result<String, Error>) -> Void) {
        fetchCalls.append(callback)
    }
}
```

In this case, we are explicitly storing the arguments that `fetch(callback:)` is
called with, and, as a convenience, changing `fetchCalled` from a stored
property to a computed property based on whether `fetchCalls` is empty or not.

Finally, we update our test code. Here, we're going to take advantage of Quick's
tree-like structure to have our tests represent the branching paths our code
takes. This allows us to re-use the same setup code (create the dependencies, load
the view, resolve the callback) without having to repeat ourselves, or create 
setup functions that we could forget to call:

```swift
final class ViewControllerSpec: QuickSpec {
    override class func spec() {
        describe("view controller") {
            var mockProvider: MockDataProvider!
            var viewController: ViewController!
                        
            beforeEach {
                mockProvider = MockDataProvider()
                viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ViewController") as! ViewController
                viewController.dataProvider = mockProvider
            }
            
            it("doesn't immediately fetch the data from the data provider") {
                expect(mockProvider.fetchCalled).to(beFalse())
            }
            
            context("when the view is loaded") {
                beforeEach {
                    _ = viewController.view
                }

                it("fetches data with the data provider") {
                    expect(mockProvider.fetchCalled).to(beTrue())
                }
            
                context("when the callback returns valid data") {
                    beforeEach {
                        mockProvider.fetchCalls.last?(.success("hello"))
                    }
                
                    it("shows the data in the resultLabel") {
                        expect(viewController.resultLabel.text).to(equal("hello"))
                    }
                }
            
                context("when the callback returns an error") {
                    beforeEach {
                        mockProvider.fetchCalls.last?(.failure(NSError()))
                    }
                
                    it("let's the user know we had an error") {
                        expect(viewController.resultLabel.text).to(equal("Error, try again"))
                    }
                }
            }
        }
    }
}
```

This example also took care to restructure the earliest tests so that each
behavior is tested in its own test, as described and encouraged in [Behavioral Testing](BehavioralTesting.md).

### Writing Mocks for Async/Await APIs in Swift

Swift Concurrency, or async/await, requires a slight change in how we mock the
return value, as well as how we structure tests to handle this. This example assumes
basic familiarity with Async/Await in Swift. If you are unfamiliar with Async/Await
in Swift, please review
[Meet Swift Concurrency](https://developer.apple.com/news/?id=2o3euotz), from
WWDC 2021.

Utilizing the previous example, what if we wanted to provide an async version of
`DataProviderProtocol.fetch(callback:)`? Assuming you're familiar with
Async/Await in swift, this is relatively easy to provide. Again, going with our
earlier example, we're going to start with the implementation code. First the
`DataProviderProtocol`:

```swift
protocol DataProviderProtocol: class {
    func fetch() async throws -> String
}
```

This is a fairly straightforward conversion. Next, we'll update the actual
`DataProvider`, in this case to use the Async/Await API for URLSession:

```swift
class DataProvider: NSObject, DataProviderProtocol {
    func fetch() async throws -> String {
        let url = URL(string: "http://example.com/")!
        let session = URLSession(configuration: .default)
        let (data, _) = try await session.dataTask(with: url)
        return String(data: data, encoding: .utf8)!
    }
}
```

Third, we'll update the ViewController to use this new Async version of `fetch()`:

```swift
class ViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var resultLabel: UILabel!
    private var dataProvider: DataProviderProtocol?
    
    private var fetchTask: Task<Void, Never>?
    
    deinit {
        fetchTask?.cancel()
    }

    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchTask = Task { [weak self] in
            await self?.fetchData()
        }
    }
    
    @MainActor
    func fetchData() async {
        let dataProvider = dataProvider ?? DataProvider()
        let labelString: String
        do {
            labelString = try await dataProvider.fetch()
        } catch {
            labelString = "Error, try again"
        }
        resultLabel.text = labelString
    }
}
```

This is slightly more complicated. Because `viewDidLoad` is not an async method,
we need to kick off a background Task to create the async context to invoke these
async methods in. This task then calls `fetchData`, which contains the bulk of
what used to be in `viewDidLoad`.  
Additionally, because `UILabel.text` must be updated on the main thread, we
need to annotate the new `fetchData` method with `@MainActor` so that we set
`resultLabel.text` on the main thread.  
Also, while not required, we are saving off the created background task, for the
explicit purpose of cancelling it when `ViewController` is deallocated.

With the implementation code updated, now it's time to update our Mock. This
is where things start to look different from what you'd expect. After much
research and experimentation, I ([@younata](https://github.com/younata), the
author) have determined that the best way to mock Async methods is to always
have them "preresolved". In contrast to earlier, where we stored the arguments
to `fetch(callback:)`, and then called the callback at our leisure; I have come
to the conclusion that the Swift Concurrency runtime does not like to have
tasks kept waiting for an indeterminate amount of time. Every mechanism I have
come up with to force this results in ~50% of the tests randomly failing.
Instead, I encourage a paradigm where mocks always return a known value. This
paradigm requires a little extra infrastructure, which is not (currently) in
Quick or Nimble. Which we'll call `AsyncResult`. `AsyncResult` is an enum which
represents the 3 states an `Async` method can return: Success, Failure, and
Pending. Part of the infrastructure we'll add is that Pending will always throw
an error return after sleeping for a bit. This enables us to still test the
intermediate state before the async method has resolved, while satisfying
Swift's need to always return a value.

```swift
import Nimble

enum AsyncResult<Value, Failure: Error> {
    case success(Value)
    case failure(Failure)
    case pending
    
    func resolve(timeout: NimbleTimeInterval = PollingDefaults.pollInterval * 2) async throws -> Value {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        case .pending:
            try await Task.sleep(for: timeout)
            throw AsyncResultTimedOutError()
        }
    }
}

struct AsyncResultTimedOutError: Error {}
```

As you can see, in the `success` or `failure` cases, `AsyncResult.resolve`
immediately returns the associated value. In the `pending` case,
`AsyncResult.resolve` will wait for some period of time (defaulting to 2 \* 
however long Nimble would poll for when using a `toEventually`-style matcher).
This value feels like a good-enough wait time.  
As-is, this mock only works with `async throws` methods. For mocking
non-throwing methods, the following extension which utilizes a fallback will work:

```swift
extension AsyncResult where Failure == Never {
    func resolve(fallback: Value, timeout: NimbleTimeInterval = PollingDefaults.pollInterval * 2) async -> Value {
        do {
            try await resolve(timeout: timeout)
        } catch {
            return fallback
        }
    }
}
```

With this infrastructure, we will update our `MockDataProvider` to use it:

```swift
class MockDataProvider: NSObject, DataProviderProtocol {
    private(set) var fetchCalled: Bool = false
    private(set) var fetchStub = AsyncResult<String, Error>.pending
    func fetch() async throws -> String {
        fetchCalled = true
        return fetchStub.resolve(fallback: .failure(NSError()))
    }
}
```

Next up, because we preresolve our mocks, we have to adjust our test structure
such that `fetch()` is called after we change the value of `fetchStub`. In our
case, this means that we want to make sure that `ViewController.viewDidLoad` is
called immediately before each of the test called. Which we'll do using the
`justBeforeEach` method in the Quick DSL. `justBeforeEach` works to add the
associated closure at the end of the set of `beforeEach` closures. Additionally,
because we'll be running background tasks, we'll need to use Nimble's polling
matchers to test that the `resultLabel` will be updated eventually.
Lastly, because this test isn't directly invoking any async calls, we do not to
make this an `AsyncSpec`. This test will still run as a traditional `QuickSpec`.

```swift
final class ViewControllerSpec: QuickSpec {
    override class func spec() {
        describe("view controller") {
            var mockProvider: MockDataProvider!
            var viewController: ViewController!
                        
            beforeEach {
                mockProvider = MockDataProvider()
                viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ViewController") as! ViewController
                viewController.dataProvider = mockProvider
            }
            
            it("doesn't immediately fetch the data from the data provider") {
                expect(mockProvider.fetchCalled).to(beFalse())
            }
            
            context("when the view is loaded") {
                justBeforeEach {
                    // if this were a regular beforeEach, MockDataProvider.fetch() would get called much too early
                    _ = viewController.view
                }

                it("fetches data with the data provider") {
                    expect(mockProvider.fetchCalled).toEventually(beTrue())
                }
            
                context("when the callback returns valid data") {
                    beforeEach {
                        mockProvider.fetchStub = .success("hello")
                    }
                
                    it("shows the data in the resultLabel") {
                        expect(viewController.resultLabel.text).toEventually(equal("hello"))
                    }
                }
            
                context("when the callback returns an error") {
                    beforeEach {
                        mockProvider.fetchStub = .failure(NSError())
                    }
                
                    it("let's the user know we had an error") {
                        // because AsyncResult has a default timeout of 2 * Nimble's polling interval,
                        // this test would fail if we had forgotten to reset mockProvider.fetchStub.
                        expect(viewController.resultLabel.text).toEventually(equal("Error, try again"))
                    }
                }
            }
        }
    }
}
```

If you're interested in learning more about writing tests, continue on to <https://realm.io/news/testing-in-swift/>.
