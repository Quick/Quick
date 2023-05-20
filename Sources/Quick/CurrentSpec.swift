import XCTest

/// A way to get either the current QuickSpec or AsyncSpec, whichever is relevant to the given context
/// This is intended to be used inside of `beforeSuite` or `afterSuite` closures, in order to access
/// `XCTestCase` APIs (e.g. `expectation(description:)` or `waitForExpectations()`)
///
/// This does not work with standard XCTest APIs - this does not provide the currently executing
/// `XCTestCase` instance for tests defined using `XCTest`.
public func currentSpec() -> XCTestCase? {
    QuickSpec.current ?? AsyncSpec.current
}
