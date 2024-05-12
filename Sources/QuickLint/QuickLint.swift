import ArgumentParser
import Foundation

/**
 Search for any Quick examples with focus and flag it if there is any focus found.

 By default, just warn on any focused examples.
 However, with the "--error" flag, the focused examples will be marked as errors.
 */
struct LintCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "lint"
    )

    @Flag(name: .long, help: "Mark focused examples as errors")
    var error: Bool = false

    @Argument
    var paths = [String]()

    var dependencies = ServiceLocator()

    mutating func run() async throws {
        let paths = self.paths.isEmpty ? [""] : self.paths
        let workingDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let urls = paths.map {
            if $0.hasPrefix("/") {
                return URL(fileURLWithPath: $0)
            } else {
                return workingDirectory.appendingPathComponent($0)
            }
        }

        if try await dependencies.linter.lint(
            urls: urls,
            errorOnIssues: error
        ) != 0 && error {
            throw ExitCode(1)
        }
    }
}

/**
 Search for any Quick examples with focus, and remove focus from it.
 */
struct DefocusCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "defocus"
    )

    @Argument
    var paths = [String]()

    var dependencies = ServiceLocator()

    mutating func run() async throws {
        let paths = self.paths.isEmpty ? [""] : self.paths
        let workingDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let urls = paths.map {
            if $0.hasPrefix("/") {
                return URL(fileURLWithPath: $0)
            } else {
                return workingDirectory.appendingPathComponent($0)
            }
        }

        try await dependencies.defocusFormatter.format(
            rootUrls: urls
        )
    }
}

@main
struct QuickMain: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A utility for linting and formatting Quick Specs for focus issues.",
        subcommands: [LintCommand.self, DefocusCommand.self],
        defaultSubcommand: LintCommand.self
    )
}
