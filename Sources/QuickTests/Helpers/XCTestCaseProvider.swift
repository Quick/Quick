import Foundation
import XCTest

// XCTestCaseProvider is defined in swift-corelibs-xctest, but is not available
// in the XCTest that ships with Xcode. By defining this protocol on Apple platforms,
// we ensure that the tests fail in Xcode if they haven't been configured properly to
// be run with the open-source tools.

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)

public protocol XCTestCaseProvider {
    var allTests: [(String, () throws -> Void)] { get }
}

extension XCTestCase {
    override public func tearDown() {
        if let provider = self as? XCTestCaseProvider {
            provider.assertContainsTest(invocation!.selector.description)
        }

        super.tearDown()
    }
}

extension XCTestCaseProvider {
    private func assertContainsTest(name: String) {
        let contains = self.allTests.contains({ test in
            return test.0 == name
        })

        XCTAssert(contains, "Test '\(name)' is missing from the allTests array")
    }
}

#endif
