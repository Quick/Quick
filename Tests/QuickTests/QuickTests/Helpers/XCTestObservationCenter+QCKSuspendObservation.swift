#if canImport(Darwin) && !SWIFT_PACKAGE
import Foundation
import XCTest

/// This allows us to only suspend observation for observers by provided by Apple
/// as a part of the XCTest framework. In particular it is important that we not
/// suspend the observer added by Nimble, otherwise it is unable to properly
/// report assertion failures.
private func isFromApple(observer: XCTestObservation) -> Bool {
    guard let bundleIdentifier = Bundle(for: type(of: observer)).bundleIdentifier else {
        return false
    }
    return bundleIdentifier.contains("com.apple.dt.XCTest")
}

/**
 Add the ability to temporarily disable internal XCTest execution observation in
 order to run isolated XCTestSuite instances while the QuickTests test suite is running.
 */
extension XCTestObservationCenter {
    /**
     Suspends test suite observation for XCTest-provided observers for the duration that
     the block is executing. Any test suites that are executed within the block do not
     generate any log output. Failures are still reported.

     Use this method to run XCTestSuite objects while another XCTestSuite is running.
     Without this method, tests fail with the message: "Timed out waiting for IDE
     barrier message to complete" or "Unexpected TestSuiteDidStart".
     */
    @objc func qck_suspendObservation(forBlock block: () -> XCTestRun?) -> XCTestRun? {
        let originalObservers = value(forKey: "observers") as? [XCTestObservation] ?? []
        var suspendedObservers = [XCTestObservation]()

        for observer in originalObservers where isFromApple(observer: observer) {
            suspendedObservers.append(observer)
            removeTestObserver(observer)
        }
        defer {
            for observer in suspendedObservers {
                addTestObserver(observer)
            }
        }

        return block()
    }
}
#endif
