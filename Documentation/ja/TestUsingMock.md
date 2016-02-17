# モックを使ったテスト

## モックとは

モックとはテスト対象のオブジェクト(クラス、構造体)が呼び出し先のオブジェクトと意図したとおりに協調動作するかどうかをテストするために使うオブジェクトのことです。

## Swift でモックを使ったテストを書く

### サンプルアプリケーション	

ここでは例として RSS reader のような記事の一覧を UITableView　で表示アプリケーションを考えます。

* Article という構造体(struct)を ArticleViewController の UITableView で表示する
* データ(Article)の取得や保持、UITableViewDataSource の処理は ArticleProviderProtocol を実装したクラスが行う

ここで ArticleProviderProtocol を定義します。

```swift
protocol ArticleProviderProtocol: UITableViewDataSource {
    var articles: [Article] { get }
    weak var tableView: UITableView! { get set }
    func setup()
    func fetch()
}
```

ArticleProviderProtocol で UITableViewDataSource を継承し、Article を保持するプロパティ、Article を取得する関数などを定義しています。

ここで ArticleProviderProtocol を実装する ArticleDataProvider クラスを定義します。

```
class ArticleDataProvider: NSObject, ArticleProviderProtocol {
    var articles = [Article]()
    weak var tableView: UITableView!
    
    func setup() {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
    }
    
    func fetch() { // 例のためテスト実装。本来はネットワーク経由などで Article を取得します
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

ArticleDataProvider を ArticleViewController の viewDidLoad 中にセットアップ、Articleの取得(fetch)を行います。

コードはこのようになります。

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

    var dataProvier: ArticleProviderProtocol?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataProvier = dataProvier ?? ArticleDataProvider() // if dataProvier is nil, assign ArticleDataProvider instance

        dataProvier?.tableView = tableView
        dataProvier?.setup()
        
        dataProvier?.fetch()
    }

}
```

## ArticleProviderProtocol のモックを使ったテストを書く

テスト用に ArticleProviderProtocol を継承したクラス(モックとして使用します)をテストターゲット内に作成します。

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

このモックの中で setupCalled プロパティを定義しています。setupCalled は setup関数が呼ばれたら true になります。
これで準備は完了です。

このモックを使ってテストをします。このテストで「ArticleViewController がロードされた時(viewDidLoad)に dataProvier プロパティを setup するか」という動作をテストしています。

```
    override func spec() {
        describe("view controller") {
            it("setup with data provider when loaded") {
                let mockProvier = MockDataProvider()
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArticleViewController") as! ArticleViewController
                viewController.dataProvier = mockProvier
                
                expect(mockProvier.setupCalled).to(equal(false))

                let _ = viewController.view // triger viewDidLoad()
                
                expect(mockProvier.setupCalled).to(equal(true))
            }
        }
    }
```

このようにオブジェクトのモックを作ることで動作をテストしやすくなります。

