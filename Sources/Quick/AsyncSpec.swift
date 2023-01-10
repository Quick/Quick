import XCTest

open class AsyncSpec: XCTestCase {
    /// Returns the currently executing spec. Use in specs that require XCTestCase
    /// methods, e.g. expectation(description:).
    public private(set) static var current: AsyncSpec?

    private var example: AsyncExample? {
        didSet {
            AsyncSpec.current = self
        }
    }

    @AsyncSpecBuilder
    open class func spec() -> [AsyncExample] {}

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
        _ = testMethodSelectors()

        return super.defaultTestSuite
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

    private class func testMethodSelectors() -> [String] {
        let examples = self.spec()

        var selectorNames = Set<String>()
        return examples.map { example in
            let selector = addInstanceMethod(for: example, classSelectorNames: &selectorNames)
            return NSStringFromSelector(selector)
        }
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

        let originalName = "test \(example.name)"
        var selectorName = originalName
        var index: UInt = 2

        while selectorNames.contains(selectorName) {
            selectorName = String(format: "%@_%tu", originalName, index)
            index += 1
        }

        selectorNames.insert(selectorName)

        let selector = NSSelectorFromString(selectorName)
        class_addMethod(self, selector, implementation, "v@:@?<v@?>")

        return selector
    }
#endif // canImport(Darwin)

#if !canImport(Darwin)
    public class var allTests: [(String, (AsyncSpec) -> () throws -> Void)] {
        let examples = self.spec()

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
}
