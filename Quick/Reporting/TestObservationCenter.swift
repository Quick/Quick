import Foundation

private let sharedTestObservationCenter = TestObservationCenter()

final public class TestObservationCenter: NSObject {
    
    public class var sharedObservationCenter: TestObservationCenter {
        return sharedTestObservationCenter
    }
    
    
    // Mark: - Test Suites
    
    public func testSuiteDidStart(run: XCTestSuiteRun) {
        if let reporter = World.sharedWorld().reporter {
            reporter.testSuiteDidStart(run)
        }
    }
    
    public func testSuiteDidStop(run: XCTestSuiteRun) {
        if let reporter = World.sharedWorld().reporter {
            reporter.testSuiteDidStop(run)
        }
    }
    
    public func testSuiteDidFail(run: XCTestSuiteRun, description: NSString, file: NSString, line: Int) {
        if let reporter = World.sharedWorld().reporter {
            reporter.testSuiteDidFail(run, description, file, line)
        }
    }
    
    
    // Mark: - Test Cases
    
    public func testCaseDidStart(run: XCTestCaseRun) {
        if let reporter = World.sharedWorld().reporter {
            reporter.testCaseDidStart(run)
        }
    }
    
    public func testCaseDidStop(run: XCTestCaseRun) {
        if let reporter = World.sharedWorld().reporter {
            reporter.testCaseDidStop(run)
        }
    }
    
    public func testCaseDidFail(run: XCTestCaseRun, description: NSString, file: NSString, line: Int) {
        if let reporter = World.sharedWorld().reporter {
            reporter.testCaseDidFail(run, description, file, line)
        }
    }
}
