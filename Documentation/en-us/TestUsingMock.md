# Testing with Mock

## Mock

Mock is object(class, struct) used for verifying test object works with other objects.
Mock simulated other objects.

## Writing test with Mock in Swift

### Sample app

For example, we show an app which has UITableview like rss reader.

* Display article(struct) using UItableView in ArticleViewController
* Custom class implements ArticleProviderProtocol is resposible for data(Article) management and UITableViewDataSource.

ArticleProviderProtocol is defined as follows,

```swift
protocol ArticleProviderProtocol: UITableViewDataSource {
    var articles: [Article] { get }
    weak var tableView: UITableView! { get set }
    func setup()
    func fetch()
}
```

ArticleProviderProtocol inherits UITableViewDataSource, define property for Articles and method of getting Articles.

```
class ArticleDataProvider: NSObject, ArticleProviderProtocol {
    var articles = [Article]()
    weak var tableView: UITableView!

    func setup() {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
    }

    func fetch() { // psuedo code, basically retrieving data from internet
        articles.append(Article(title: "news title 1"))
        articles.append(Article(title: "news title 2"))
        articles.append(Article(title: "news title 3"))
        tableView.reloadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let article = articles[indexPath.row]
        cell.textLabel!.text = article.title
        return cell
    }
}
```

In our scenario, `setup()` and `fetch()` are called in `viewDidLoad()` of ArticleViewController.

Code is below.

```swift
struct Article {
    var title: String

    init(title: String) {
        self.title = title
    }
}
```

```swift
class ArticleViewController: UIViewController {

    var dataProvider: ArticleProviderProtocol?
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        dataProvider = dataProvider ?? ArticleDataProvider() // if dataProvider is nil, assign ArticleDataProvider instance

        dataProvider?.tableView = tableView
        dataProvider?.setup()

        dataProvider?.fetch()
    }

}
```

## Writing test with Mock of ArticleProviderProtocol

Create Mock which inherits ArticleProviderProtocol in Test Targets.

```
class MockDataProvider: NSObject, ArticleProviderProtocol {
    var setupCalled = false

    var articles = [Article]()
    weak var tableView: UITableView!

    func setup() {
        setupCalled = true
    }

    func fetch() {        }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

```

`setupCalled` property is deinfed in Mock. `setupCalled` is set to `true` when `setup()` called.
Ready to run test!

This test verifies that `When ArticleViewController is loaded, ArticleViewController calls dataProvider.setup()`.

```
override func spec() {
    describe("view controller") {
        it("setup with data provider when loaded") {
            let mockProvier = MockDataProvider()
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArticleViewController") as! ArticleViewController
            viewController.dataProvider = mockProvier
            
            expect(mockProvier.setupCalled).to(equal(false))

            let _ = viewController.view // triger viewDidLoad()
            
            expect(mockProvier.setupCalled).to(equal(true))
        }
    }
}
```

Mock makes us easy to verify behavior which works with other objects.

