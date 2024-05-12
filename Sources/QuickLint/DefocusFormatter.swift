import Foundation

protocol DefocusFormatter: Sendable {
    func format(rootUrls: [URL]) async throws
}

struct FoundationDefocusFormatter: DefocusFormatter {
    let detector: FileDetector
    let fileInterface: FileInterface

    func format(rootUrls: [URL]) async throws {
        let detectedFiles = try await detector.files(
            matching: focusRegexString,
            at: rootUrls,
            fileExtension: focusFileExtension
        )

        try await withThrowingTaskGroup(of: Void.self, body: { taskGroup in
            for match in detectedFiles {
                taskGroup.addTask {
                    try self.format(url: match.url)
                }
            }

            try await taskGroup.waitForAll()
        })
    }

    private func format(url: URL) throws {
        let contents = try fileInterface.read(url: url)
        let regex = try NSRegularExpression(pattern: focusRegexString)

        let output = regex.stringByReplacingMatches(
            in: contents,
            range: contents.nsRange,
            withTemplate: "$1\\("
        )
        try fileInterface.write(contents: output, to: url)
    }
}
