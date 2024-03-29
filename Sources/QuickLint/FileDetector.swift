import Algorithms
import Foundation

struct RegexMatch: Sendable, Comparable {
    let url: URL
    let line: UInt
    let character: UInt

    static func < (lhs: RegexMatch, rhs: RegexMatch) -> Bool {
        if lhs.url == rhs.url {
            if lhs.line == rhs.line {
                return lhs.character < rhs.character
            }
            return lhs.line < rhs.line
        }
        return lhs.url.absoluteString < rhs.url.absoluteString
    }
}

/**
 FileDetector specifies the behavior for performing a regex
 on multiple files (as detected in the directories passed in)
 whose file extension matches the given regex.
 */
protocol FileDetector: Sendable {
    /**
     Return files, lines and characters that match the given regex,
     are under the hierarchy of the file urls passed in,
     and whose extension matches the given fileExtension regex.

     - parameter matching: The regex to search the contents of a candidate
     file for.
     - parameter at: The directories to enumerate over to find files to search
     for.
     - parameter fileExtension: The regex specifying the extension that all
     candidate files must have before we search there contents.
     - returns: A list of ``RegexMatch`` results, containing the file (as a
     URL), the line, and characters that match.
     If the content of a file matches the `matching` regex multiple times,
     then there will be an equal number of `RegexMatch` for that same file.
     */
    func files(matching regex: String, at urls: [URL], fileExtension: String) async throws -> [RegexMatch]
}

struct FoundationFileDetector: FileDetector {
    let directoryManager: DirectoryManager
    let fileInterface: FileInterface

    func files(matching regex: String, at urls: [URL], fileExtension: String) async throws -> [RegexMatch] {
        let regularExpression = try NSRegularExpression(pattern: regex)
        let fileExtensionRegex = try NSRegularExpression(pattern: fileExtension)
        return try await withThrowingTaskGroup(of: [RegexMatch].self, returning: [RegexMatch].self) { taskGroup in
            let urls = try await deepEnumerateDirectories(at: urls)
            for url in urls where fileExtensionRegex.hasMatch(url.pathExtension) {
                taskGroup.addTask {
                    return try self.urlContentsMatch(
                        regex: regularExpression,
                        url: url
                    ).map { lineNumber, character in
                        return RegexMatch(url: url, line: lineNumber, character: character)
                    }
                }
            }

            var results: [RegexMatch] = []
            for try await result in taskGroup {
                results.append(contentsOf: result)
            }
            return results
        }
    }

    private func deepEnumerateDirectories(at urls: [URL]) async throws -> [URL] {
        return try await withThrowingTaskGroup(of: [URL].self) { taskGroup in
            for url in urls {
                taskGroup.addTask {
                    try await deepEnumerateDirectory(at: url)
                }
            }

            var foundUrls: [URL] = []
            for try await result in taskGroup {
                foundUrls.append(contentsOf: result)
            }
            return foundUrls.uniqued { $0.absoluteString }
        }
    }

    private func deepEnumerateDirectory(at url: URL) async throws -> [URL] {
        var urls = try await directoryManager.contentsOf(directory: url)
        for subUrl in urls {
            if subUrl.hasDirectoryPath {
                urls.append(
                    contentsOf: try await directoryManager.contentsOf(
                        directory: subUrl
                    )
                )
            }
        }
        return urls
    }

    // returns the line number if the contents of the url match the regex.
    // returns nil otherwise.
    private func urlContentsMatch(regex: NSRegularExpression, url: URL) throws -> [(line: UInt, character: UInt)] {
        let contents = try fileInterface.read(url: url)
        let nsContents = NSString(string: contents)

        return regex.matches(in: contents, range: contents.nsRange)
            .compactMap { (textCheckingResult: NSTextCheckingResult) -> NSRange? in
                if textCheckingResult.numberOfRanges == 0 { return nil }

                let range = textCheckingResult.range(at: 0)
                if range.location == NSNotFound { return nil }
                return range
            }
            .uniqued()
            .map { (range: NSRange) -> (line: UInt, character: UInt) in
                let lines = nsContents
                    .substring(to: range.location)
                    .components(separatedBy: CharacterSet.newlines)
                return (
                    UInt(lines.count),
                    UInt((lines.last?.count ?? 0) + 1)
                )
            }
    }
}

extension NSRegularExpression {
    func hasMatch(_ string: String) -> Bool {
        self.firstMatch(in: string, range: string.nsRange) != nil
    }
}

extension String {
    var nsRange: NSRange {
        NSRange(location: 0, length: utf16.count)
    }
}
