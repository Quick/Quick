import XCTest

// NOTE: This file is not intended to be included in the Xcode project or CocoaPods.
//       It is picked up by the Swift Package Manager during its build process.

public class QuickSpec: XCTestCase, XCTestCaseProvider {
    public func spec() {}

    public required init() {}

    public var allTests : [(String, () -> Void)] {
        gatherExamplesIfNeeded()

        let examples = World.sharedWorld.examples(self.dynamicType)
        return examples.map({ example -> (String, () -> Void) in
            return (example.name, { example.run() })
        })
    }

    internal func gatherExamplesIfNeeded() {
        let world = World.sharedWorld
        let rootExampleGroup = world.rootExampleGroupForSpecClass(self.dynamicType)
        if rootExampleGroup.examples.isEmpty {
            world.currentExampleGroup =  rootExampleGroup
            spec()
            world.currentExampleGroup = nil
        }
    }
}
