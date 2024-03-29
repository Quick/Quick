import Fakes
import Foundation
@testable import QuickLint

final class FakeFileDetector: FileDetector {
    let filesSpy = ThrowingPendableSpy<(matching: String, urls: [URL], fileExtension: String), [RegexMatch], Error>()
    func files(matching regex: String, at urls: [URL], fileExtension: String) async throws -> [RegexMatch] {
        return try await filesSpy((regex, urls, fileExtension))
    }
}
