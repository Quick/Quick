import Foundation

let focusRegexString = "f(describe|context|itBehavesLike|it)\\("
let focusFileExtension = "^(swift|m|mm)$" // swift, objective-c, objective-c++

protocol FocusLint: Sendable {
    func lint(urls: [URL], errorOnIssues: Bool) async throws
}

struct XcodeFocusLint: FocusLint {
    let detector: FileDetector
    let output: Writer

    func lint(urls: [URL], errorOnIssues: Bool) async throws {
        let results = try await detector.files(
            matching: focusRegexString,
            at: urls,
            fileExtension: focusFileExtension
        ).sorted()

        if results.isEmpty == false {
            output.stderr(lines: results.map { generateXcodeOutput(for: $0, errorOnIssues: errorOnIssues) })
        }
    }

    private func generateXcodeOutput(for result: RegexMatch, errorOnIssues: Bool) -> String {
        return [
            "\(result.url.path)",
            ":\(result.line)",
            ":\(result.character): ",
            "\(errorOnIssues ? "error" : "warning"): ",
            "Focused Spec Detected."
        ].joined()
    }
}
