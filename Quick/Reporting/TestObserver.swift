import Foundation

@objc public protocol TestObserver: class {
    
    init()
    
    // Mark: - Test Suites
    
    func testSuiteDidStart(run: XCTestSuiteRun)
    func testSuiteDidStop(run: XCTestSuiteRun)
    func testSuiteDidFail(run: XCTestSuiteRun, _ description: NSString, _ file: NSString, _ line: Int)
    
    
    // Mark: - Test Cases
    
    func testCaseDidStart(run: XCTestCaseRun)
    func testCaseDidStop(run: XCTestCaseRun)
    func testCaseDidFail(run: XCTestCaseRun, _ description: NSString, _ file: NSString, _ line: Int)
}
