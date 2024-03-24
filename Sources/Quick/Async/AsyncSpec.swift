import XCTest

#if canImport(QuickObjCRuntime)
import QuickObjCRuntime

public typealias AsyncSpecBase = _QuickSpecBase
#else
public typealias AsyncSpecBase = XCTestCase
#endif

open class AsyncSpec: AsyncSpecBase {
    /// Returns the currently executing spec. Use in specs that require XCTestCase
    /// methods, e.g. expectation(description:).
    ///
    /// If you're using `beforeSuite`/`afterSuite`, you should consider the ``currentSpec()`` helper.
    public private(set) static var current: AsyncSpec!

    private var example: AsyncExample? {
        didSet {
            AsyncSpec.current = self
        }
    }

    open class func spec() {}

#if canImport(Darwin)
    /// This method is used as a hook for the following two purposes
    ///
    /// 1. Performing all configurations
    /// 2. Gathering examples for each spec classes
    ///
    /// On Linux, those are done in `LinuxMain.swift` and `Quick.QCKMain`. But
    /// SwiftPM on macOS does not have the mechanism (test cases are automatically
    /// discovered powered by Objective-C runtime), so we needed the alternative
    /// way.
    override open class var defaultTestSuite: XCTestSuite {
        QuickConfiguration.configureSubclassesIfNeeded(world: World.sharedWorld)

        // Let's gather examples for each spec classes. This has the same effect
        // as listing spec classes in `LinuxMain.swift` on Linux.
        gatherExamplesIfNeeded()

        return super.defaultTestSuite
    }

    @objc
    class func buildExamplesIfNeeded() {
        gatherExamplesIfNeeded()
    }

    /// This method is used as a hook for injecting test methods into the
    /// Objective-C runtime on individual test runs.
    ///
    /// When `xctest` runs a test on a single method, it does not call
    /// `defaultTestSuite` on the test class but rather calls
    /// `instancesRespondToSelector:` to build its own suite.
    ///
    /// In normal conditions, Quick uses the implicit call to `defaultTestSuite`
    /// to both generate examples and inject them as methods by way of
    /// `testInvocations`.  Under single test conditions, there's no implicit
    /// call to `defaultTestSuite` so we make it explicitly here.
    open override class func instancesRespond(to aSelector: Selector!) -> Bool {
        _ = self.defaultTestSuite
        return super.instancesRespond(to: aSelector)
    }

#if SWIFT_PACKAGE
    open override class func _qck_testMethodSelectors() -> [String]! {
        darwinXCTestMethodSelectors()
    }
#endif // SWIFT_PACKAGE

    @objc
    internal class func darwinXCTestMethodSelectors() -> [String]! {
        let examples = AsyncWorld.sharedWorld.examples(forSpecClass: self)

        var selectorNames = Set<String>()
        return examples.map { test in
            let selector = addInstanceMethod(for: test.example, runFullTest: test.runFullTest, classSelectorNames: &selectorNames)
            return NSStringFromSelector(selector)
        }
    }

    private static func addInstanceMethod(for example: AsyncExample, runFullTest: Bool, classSelectorNames selectorNames: inout Set<String>) -> Selector {
        let block: @convention(block) (AsyncSpec, @escaping () -> Void) -> Void = { spec, completionHandler in
            Task {
                spec.example = example
                if runFullTest {
                    await example.run()
                } else {
                    await example.runSkippedTest()
                }
                AsyncSpec.current = nil
                completionHandler()
            }
        }
        let implementation = imp_implementationWithBlock(block as Any)

        let selectorName = TestSelectorNameProvider.testSelectorName(forAsync: example, classSelectorNames: selectorNames)

        selectorNames.insert(selectorName)

        let selector = NSSelectorFromString(selectorName)
        class_addMethod(self, selector, implementation, "v@:@?<v@?>")

        return selector
    }
#endif // canImport(Darwin)

#if !canImport(Darwin)
    public required init() {
        super.init(name: "", testClosure: { _ in })
    }

    public required init(name: String, testClosure: @escaping (XCTestCase) throws -> Swift.Void) {
        super.init(name: name, testClosure: testClosure)
    }

    public class var allTests: [(String, (AsyncSpec) -> () throws -> Void)] {
        gatherExamplesIfNeeded()

        let tests = AsyncWorld.sharedWorld.examples(forSpecClass: self)

        let result = tests.map { (example, runFullTest) -> (String, (AsyncSpec) -> () throws -> Void) in
            return (example.name, asyncTest { spec in
                return {
                    spec.example = example
                    if runFullTest {
                        await example.run()
                    } else {
                        await example.runSkippedTest()
                    }
                    AsyncSpec.current = nil
                }
            })
        }
        return result
    }
#endif // !canImport(Darwin)

    internal static func gatherExamplesIfNeeded() {
        let world = AsyncWorld.sharedWorld
        let rootExampleGroup = world.rootExampleGroup(forSpecClass: self)
        guard rootExampleGroup.examples.isEmpty else {
            return
        }

        world.performWithCurrentExampleGroup(rootExampleGroup) {
            self.spec()
        }
    }
}
