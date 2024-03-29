import Foundation

/// A simple wrapper protocol for reading and writing a file.
///
/// This allows you to inject a FileReader instance in test, instead of
/// having to actually touch the file system.
protocol FileInterface: Sendable {
    func read(url: URL) throws -> String
    func write(contents: String, to url: URL) throws
}

struct SimpleFileInterface: FileInterface {
    func read(url: URL) throws -> String {
        try String(contentsOf: url)
    }

    func write(contents: String, to url: URL) throws {
        try contents.write(to: url, atomically: true, encoding: .utf8)
    }
}
