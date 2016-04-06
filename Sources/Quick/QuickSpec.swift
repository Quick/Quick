import XCTest

// NOTE: This file is not intended to be included in the Xcode project or CocoaPods.
//       It is picked up by the Swift Package Manager during its build process.

public class QuickSpec: XCTestCase {
    public func spec() {}

#if os(Linux)
    public required init() {}
#else
    public required override init() {
        super.init()
    }
#endif

    public class var allTests : [(String, XCTestCase throws -> Void)] {
        gatherExamplesIfNeeded()

        let examples = World.sharedWorld.examples(self)
        return examples.map({ example -> (String, XCTestCase throws -> Void) in
            return (example.name, { _ in example.run() })
        })
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
