/// Stops execution of test when thrown inside an `it` block, emitting a failure message.
///
/// Unlike other errors that can be thrown during a test, `StopTest` represents an expected
/// failure, with the failure description tied to the file and line it is thrown on.
///
/// Tests can also be stopped silently by throwing `StopTest.silently`.
///
/// The primary use case of `StopTest` as opposed to normal error logging is when a condition
/// is critical for the remainder of the test.  It serves as an alternative to force unwrapping
/// or out-of-range subscripts that could be cause the test to crash.
///
/// For example,
///
/// ```
/// guard let value = getValue() else {
///     throw StopTest("Got a null value from `getValue()`)
/// }
/// ```
///
/// When used with Nimble, any expectation can stop a test by adding
/// `.onFailure(throw: StopTest.silently)`.
///
/// For example,
///
/// ```
/// try expect(array).toEventually(haveCount(10)).onFailure(throw: StopTest.silently)
/// ```
public struct StopTest: Error {
    public let failureDescription: String
    public let reportError: Bool
    public let callsite: Callsite

    /// A private initializer to support creating the `silently` singleton.
    private init(_ failureDescription: String, reportError: Bool, file: FileString, line: UInt) {
        self.failureDescription = failureDescription
        self.reportError = reportError
        self.callsite = .init(file: file, line: line)
    }

    /// Returns a new `StopTest` instance that, when thrown, stops the test and logs an error.
    ///
    /// - parameter failureDescription: The message to display in the test results.
    /// - parameter file: The absolute path to the file containing the error. A sensible default is provided.
    /// - parameter line: The line containing the error. A sensible default is provided.
    public init(_ failureDescription: String, file: FileString = #file, line: UInt = #line) {
        self.init(failureDescription, reportError: true, file: file, line: line)
    }

    /// An error that, when thrown, stops the test without logging an error.
    ///
    /// This is meant to be used alongside methods that have already logged a test failure.
    ///
    /// For example,
    ///
    /// ```
    /// func checkProperty() -> Bool {
    ///     if property.isValid {
    ///         return true
    ///     } else {
    ///         XCTFail("\(property) is not valid")
    ///         return false
    ///     }
    /// }
    ///
    /// guard checkProperty() else {
    ///     throw StopTest.error
    /// }
    /// ```
    public static let silently: StopTest = .init("", reportError: false, file: #file, line: #line)
}
