public struct StopTest: Error {
    public let failureDescription: String
    public let reportError: Bool
    public let callsite: Callsite

    private init(_ failureDescription: String, reportError: Bool, file: FileString, line: UInt) {
        self.failureDescription = failureDescription
        self.reportError = reportError
        self.callsite = .init(file: file, line: line)
    }

    public init(_ failureDescription: String, file: FileString = #file, line: UInt = #line) {
        self.init(failureDescription, reportError: true, file: file, line: line)
    }
    
    public static let silently: StopTest = .init("", reportError: false, file: #file, line: #line)
}
