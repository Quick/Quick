import XCTest

// NOTE: This file is not intended to be included in the Xcode project or CocoaPods.
//       It is picked up by the Swift Package Manager during its build process.

open class QuickSpec: XCTestCase {
    open func spec() {}

#if os(Linux)
    public required init() {
        super.init(name: "", testClosure: { _ in })
    }
    public required init(name: String, testClosure: @escaping (XCTestCase) throws -> Swift.Void) {
        super.init(name: name, testClosure: testClosure)
    }
#else
    public required override init() {
        super.init()
    }
#endif

    static var allTestsCache = [String : [(String, (XCTestCase) -> () throws -> Void)]]()

    public class var allTests : [(String, (XCTestCase) -> () throws -> Void)] {
        if let cached = allTestsCache[String(describing: self)] {
            return cached
        }

        gatherExamplesIfNeeded()

        let examples = World.sharedWorld.examples(self)
        let result = examples.map { example -> (String, (XCTestCase) -> () throws -> Void) in
            return (example.name, { _ in { example.run() } })
        }
        allTestsCache[String(describing: self)] = result
        return result
    }

    internal static func gatherExamplesIfNeeded() {
        let world = World.sharedWorld
        let rootExampleGroup = world.rootExampleGroupForSpecClass(self)
        if rootExampleGroup.examples.isEmpty {
            world.currentExampleGroup =  rootExampleGroup
            self.init().spec()
            world.currentExampleGroup = nil
        }
    }
}
