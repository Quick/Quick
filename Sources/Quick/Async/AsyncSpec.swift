import XCTest

open class AsyncSpec: XCTestCase {
    /// Returns the currently executing spec. Use in specs that require XCTestCase
    /// methods, e.g. expectation(description:).
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

    class func insertDarwinXCTestInstanceMethods() {
        let world = AsyncWorld.sharedWorld

        let examples = world.examples(forSpecClass: self)

        var selectorNames = Set<String>()
        for example in examples {
            _ = addInstanceMethod(for: example, classSelectorNames: &selectorNames)
        }
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

    private static func addInstanceMethod(for example: AsyncExample, classSelectorNames selectorNames: inout Set<String>) -> Selector {
        let block: @convention(block) (AsyncSpec, @escaping () -> Void) -> Void = { spec, completionHandler in
            spec.example = example
            Task {
                await example.run()
                completionHandler()
                AsyncSpec.current = nil
            }
        }
        let implementation = imp_implementationWithBlock(block as Any)

        // The Objc version of QuickSpec can override `testInvocations`, allowing it to
        // omit the leading "test ". Unfortunately, there's not a similar API available
        // to Swift. So the compromise is this.
        let originalName = "test \(example.name)"
        var selectorName = originalName
        var index: UInt = 2

        while selectorNames.contains(selectorName) {
            selectorName = String(format: "%@ (%tu)", originalName, index)
            index += 1
        }

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

        let examples = AsyncWorld.sharedWorld.examples(forSpecClass: self)

        let result = examples.map { example -> (String, (AsyncSpec) -> () throws -> Void) in
            return (example.name, asyncTest { spec in
                return {
                    spec.example = example
                    await example.run()
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

        #if canImport(Darwin)
        insertDarwinXCTestInstanceMethods()
        #endif
    }
}
