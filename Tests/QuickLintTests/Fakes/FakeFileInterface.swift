import Fakes
import Foundation
@testable import QuickLint

final class FakeFileInterface: FileInterface {
    let readSpy = ThrowingSpy<URL, String, Error>(success: "")
    func read(url: URL) throws -> String {
        return try readSpy(url)
    }

    let writeSpy = ThrowingSpy<(contents: String, url: URL), Void, Error>()
    func write(contents: String, to url: URL) throws {
        return try writeSpy((contents, url))
    }
}
