import Foundation

/// A simple wrapper protocol for enumerating the contents of a directory.
protocol DirectoryManager: Sendable {
    /// Return a list of the contents of the directory at the given URL.
    ///
    /// - parameter directory: The directory as a URL to enumerate.
    /// - returns: The contents of the directory. This is a deep enumeration,
    /// however, no symlinks will be followed.
    func contentsOf(directory: URL) async throws -> [URL]
}

/// A type which wraps ``FileManager`` in an actor.
actor FoundationDirectoryManager: DirectoryManager {
    let fileManager: FileManager = .default

    func contentsOf(directory: URL) throws -> [URL] {
        if isDirectory(url: directory) {
            do {
                return try fileManager.contentsOfDirectory(
                    at: directory,
                    includingPropertiesForKeys: [.isDirectoryKey],
                    options: []
                ).flatMap { file in
                    try self.contentsOf(directory: file)
                }
            } catch {
                return []
            }
        } else {
            return [directory]
        }
    }

    private func isDirectory(url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        if fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) {
            return isDirectory.boolValue
        }
        return false
    }
}
