import XCTest

// NOTE: This file is not intended to be included in the Xcode project or CocoaPods.
//       It is picked up by the Swift Package Manager during its build process.

#if SWIFT_PACKAGE

#if canImport(QuickObjCRuntime)
import QuickObjCRuntime

public typealias QuickSpecBase = _QuickSpecBase
#else
public typealias QuickSpecBase = XCTestCase
#endif

open class QuickSpec: QuickSpecBase {
    /// Returns the currently executing spec. Use in specs that require XCTestCase
    /// methods, e.g. expectation(description:).
    ///
    /// If you're using `beforeSuite`/`afterSuite`, you should consider the ``currentSpec()`` helper.
    public private(set) static var current: QuickSpec!

    private var example: Example? {
        didSet {
            QuickSpec.current = self
        }
    }

    @MainActor
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

    override open class func _qck_testMethodSelectors() -> [String] {
        let examples = World.sharedWorld.examples(forSpecClass: self)

        var selectorNames = Set<String>()
        return examples.map { (test: ExampleWrapper) in
            let selector = addInstanceMethod(for: test.example, runFullTest: test.runFullTest, classSelectorNames: &selectorNames)
            return NSStringFromSelector(selector)
        }
    }

    private static func addInstanceMethod(for example: Example, runFullTest: Bool, classSelectorNames selectorNames: inout Set<String>) -> Selector {
        let block: @convention(block) @MainActor (QuickSpec) -> Void = { spec in
            spec.example = example
            if runFullTest {
                example.run()
            } else {
                example.runSkippedTest()
            }
            QuickSpec.current = nil
        }
        let implementation = imp_implementationWithBlock(block as Any)

        let selectorName = TestSelectorNameProvider.testSelectorName(for: example, classSelectorNames: selectorNames)

        selectorNames.insert(selectorName)

        let selector = NSSelectorFromString(selectorName)
        class_addMethod(self, selector, implementation, "v@:")

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

    public class var allTests: [(String, (QuickSpec) -> () throws -> Void)] {
        gatherExamplesIfNeeded()

        let exampleWrappers = World.sharedWorld.examples(forSpecClass: self)
        let result = exampleWrappers.map { wrapper -> (String, (QuickSpec) -> () throws -> Void) in
            return (wrapper.example.name, { spec in
                let example = wrapper.example
                return { @MainActor in
                    spec.example = example
                    if wrapper.runFullTest {
                        example.run()
                    } else {
                        example.runSkippedTest()
                    }
                    QuickSpec.current = nil
                }
            })
        }
        return result
    }
#endif

    internal static func gatherExamplesIfNeeded() {
        let world = World.sharedWorld
        let rootExampleGroup = world.rootExampleGroup(forSpecClass: self)
        guard rootExampleGroup.examples.isEmpty else {
            return
        }

        world.performWithCurrentExampleGroup(rootExampleGroup) {
            self.spec()
        }
    }

    // MARK: Delegation to `QuickSpec.current`.

    override public func recordFailure(
        withDescription description: String,
        inFile filePath: String,
        atLine lineNumber: Int,
        expected: Bool
    ) {
        guard self === Self.current else {
            Self.current.recordFailure(
                withDescription: description,
                inFile: filePath,
                atLine: lineNumber,
                expected: expected
            )
            return
        }

        super.recordFailure(
            withDescription: description,
            inFile: filePath,
            atLine: lineNumber,
            expected: expected
        )
    }
}

#endif
