import Quick
import Nimble
import Foundation
@testable import QuickLint

final class FileDetectorSpec: AsyncSpec {
    override class func spec() {
        @TestState var subject: FileDetector! = FoundationFileDetector(
            directoryManager: FoundationDirectoryManager(),
            fileInterface: SimpleFileInterface()
        )

        describe("files(matching:at:fileExtension:)") {
            it("identifies files matching the regex & file extension in the given directory structure") {
                let currentDirectory = URL(fileURLWithPath: #filePath)
                let specDirectory = currentDirectory
                    .deletingLastPathComponent()
                    .deletingLastPathComponent()
                let lintFixturesDirectory = specDirectory
                    .appendingPathComponent("LintFixtures")

                await expect {
                    try await subject.files(
                        matching: "f(it|context)",
                        at: [lintFixturesDirectory],
                        fileExtension: "swift"
                    ).sorted()
                }.to(equal([
                    RegexMatch(
                        url: lintFixturesDirectory
                            .appendingPathComponent("SampleSpec.swift"),
                        line: 6,
                        character: 9
                    ),
                    RegexMatch(
                        url: lintFixturesDirectory
                            .appendingPathComponent("SampleSpec.swift"),
                        line: 16,
                        character: 9
                    ),
                    RegexMatch(
                        url: lintFixturesDirectory
                            .appendingPathComponent("SampleSpec.swift"),
                        line: 21,
                        character: 9
                    ),
                    RegexMatch(
                        url: lintFixturesDirectory
                            .appendingPathComponent("Nesting")
                            .appendingPathComponent("Nesting.swift"),
                        line: 7,
                        character: 13
                    ),
                    RegexMatch(
                        url: lintFixturesDirectory
                            .appendingPathComponent("Nesting")
                            .appendingPathComponent("Nesting.swift"),
                        line: 10,
                        character: 9
                    ),
                    RegexMatch(
                        url: lintFixturesDirectory
                            .appendingPathComponent("Nesting")
                            .appendingPathComponent("Nesting.swift"),
                        line: 10,
                        character: 62
                    ),
                ].sorted()))
            }

            it("identifies files matching the regex & file extension when given the exact files to search") {
                let currentDirectory = URL(fileURLWithPath: #filePath)
                let specDirectory = currentDirectory.deletingLastPathComponent().deletingLastPathComponent()
                let lintFixturesDirectory = specDirectory.appendingPathComponent("LintFixtures")
                let files: [URL] = [
                    lintFixturesDirectory
                        .appendingPathComponent("SampleSpec.swift"),
                    lintFixturesDirectory
                        .appendingPathComponent("Nesting")
                        .appendingPathComponent("Nesting.swift")
                ]

                await expect {
                    try await subject.files(
                        matching: "f(it|context)",
                        at: files,
                        fileExtension: "swift"
                    ).sorted()
                }.to(equal([
                    RegexMatch(
                        url: lintFixturesDirectory
                            .appendingPathComponent("SampleSpec.swift"),
                        line: 6,
                        character: 9
                    ),
                    RegexMatch(
                        url: lintFixturesDirectory
                            .appendingPathComponent("SampleSpec.swift"),
                        line: 16,
                        character: 9
                    ),
                    RegexMatch(
                        url: lintFixturesDirectory
                            .appendingPathComponent("SampleSpec.swift"),
                        line: 21,
                        character: 9
                    ),
                    RegexMatch(
                        url: lintFixturesDirectory
                            .appendingPathComponent("Nesting")
                            .appendingPathComponent("Nesting.swift"),
                        line: 7,
                        character: 13
                    ),
                    RegexMatch(
                        url: lintFixturesDirectory
                            .appendingPathComponent("Nesting")
                            .appendingPathComponent("Nesting.swift"),
                        line: 10,
                        character: 9
                    ),
                    RegexMatch(
                        url: lintFixturesDirectory
                            .appendingPathComponent("Nesting")
                            .appendingPathComponent("Nesting.swift"),
                        line: 10,
                        character: 62
                    ),
                ].sorted()))
            }
        }
    }
}
