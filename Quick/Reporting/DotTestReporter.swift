import Foundation

final public class DotTestReporter: NSObject, TestObserver {
    
    // Mark: Test Suites
    
    public func testSuiteDidStart(run: XCTestSuiteRun) {
        // No-op
    }
    
    public func testSuiteDidStop(run: XCTestSuiteRun) {
        // No-op
    }
    
    public func testSuiteDidFail(run: XCTestSuiteRun, _ description: NSString, _ file: NSString, _ line: Int) {
        // No-op
    }
    
    
    // Mark: - Test Cases
    
    public func testCaseDidStart(run: XCTestCaseRun) {
        // No-op
    }
    
    public func testCaseDidStop(run: XCTestCaseRun) {
        fputs(".\u{200b}", __stderrp)
    }
    
    public func testCaseDidFail(run: XCTestCaseRun, _ description: NSString, _ file: NSString, _ line: Int) {
        fputs("F\u{200b}", __stderrp)
    }
}
