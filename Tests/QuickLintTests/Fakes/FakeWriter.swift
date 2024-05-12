import Fakes
@testable import QuickLint

final class FakeWriter: Writer {
    let stderrSpy = Spy<[String], Void>()
    func stderr(lines: [String]) {
        return stderrSpy(lines)
    }
}
