import Foundation

/// A simple wrapper protocol for enumerating the contents of a directory.
protocol DirectoryManager: Sendable {
    /// Return a list of the contents of the directory at the given URL.
    ///
    /// - parameter directory: The directory as a URL to enumerate.
    /// - returns: The contents of the directory. This is not a deep-enumeration.
    /// No subfolders are searched, nor are any symlinks followed.
    func contentsOf(directory: URL) async throws -> [URL]
}

/// A type which wraps ``FileManager`` in an actor.
actor FoundationDirectoryManager: DirectoryManager {
    let fileManager: FileManager = .default

    func contentsOf(directory: URL) throws -> [URL] {
        try fileManager.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: []
        )
    }
}
