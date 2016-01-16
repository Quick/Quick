import Foundation
import XCTest

// XCTestCaseProvider is defined on Linux as part of swift-corelibs-xctest,
// but is not available on OS X. By defining this protocol on OS X, we ensure
// that the tests fail on OS X if they haven't been configured properly to
// be run on Linux

#if !os(Linux)

public protocol XCTestCaseProvider {
    var allTests : [(String, () -> Void)] { get }
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
