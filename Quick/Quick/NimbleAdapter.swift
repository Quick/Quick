import Foundation
import Nimble
import XCTest

@objc class QuickNimbleAdapter : NSObject, AssertionHandler {
    var currentTestCase: XCTestCase?
    var sharedExampleCallsite: Callsite?

    func reportToTestCase(testCase: XCTestCase, sharedExampleCallsite: Callsite?, failuresInBlock: () -> Void) {
        let originalTestCase = currentTestCase
        let originalCallsite = self.sharedExampleCallsite

        currentTestCase = testCase
        self.sharedExampleCallsite = sharedExampleCallsite

        withAssertionHandler(self) {
            failuresInBlock()
        }

        self.sharedExampleCallsite = originalCallsite
        currentTestCase = originalTestCase
    }

    func assert(assertion: Bool, message: String, location: SourceLocation) {
        if !assertion {
            var file: String
            var line: Int
            if let callsite = sharedExampleCallsite {
                file = callsite.file
                line = callsite.line
            } else {
                file = location.file
                line = location.line
            }
            currentTestCase!.recordFailureWithDescription(message, inFile: file, atLine: line, expected: false)
        }
    }
}

