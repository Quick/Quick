import Fakes
import Quick
import Nimble
import Foundation
import ArgumentParser
@testable import QuickLint

final class LintCommandSpec: AsyncSpec {
    override class func spec() {
        let rootURL = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("LintFixtures")

        context("when given a directory to search") {
            it("identifies any focused specs") {
                var subject = LintCommand()
                subject.paths = [rootURL.path]
                subject.error = false

                let writer = FakeWriter()

                subject.dependencies.writer = writer

                let result = await Result<Void, Error> {
                    try await subject.run()
                }

                expect(writer.stderrSpy).to(beCalled([
                    "\(rootURL.path)/Nesting/Nesting.swift:6:9: warning: Focused Spec Detected.",
                    "\(rootURL.path)/Nesting/Nesting.swift:7:13: warning: Focused Spec Detected.",
                    "\(rootURL.path)/Nesting/Nesting.swift:10:9: warning: Focused Spec Detected.",
                    "\(rootURL.path)/Nesting/Nesting.swift:10:62: warning: Focused Spec Detected.",
                    "\(rootURL.path)/SampleSpec.swift:6:9: warning: Focused Spec Detected.",
                    "\(rootURL.path)/SampleSpec.swift:11:9: warning: Focused Spec Detected.",
                    "\(rootURL.path)/SampleSpec.swift:16:9: warning: Focused Spec Detected.",
                    "\(rootURL.path)/SampleSpec.swift:21:9: warning: Focused Spec Detected."
                ]))

                expect { try result.get() }.toNot(throwError())
            }
        }

        context("when given the precise paths to the specs") {
            it("identifies any focused specs") {
                let sampleSpec = rootURL
                    .appendingPathComponent("SampleSpec.swift")
                let nesting = rootURL
                    .appendingPathComponent("Nesting")
                    .appendingPathComponent("Nesting.swift")

                var subject = LintCommand()
                subject.paths = [sampleSpec.path, nesting.path]
                subject.error = true

                let writer = FakeWriter()

                subject.dependencies.writer = writer

                let result = await Result<Void, Error> {
                    try await subject.run()
                }

                expect(writer.stderrSpy).to(beCalled([
                    "\(rootURL.path)/Nesting/Nesting.swift:6:9: error: Focused Spec Detected.",
                    "\(rootURL.path)/Nesting/Nesting.swift:7:13: error: Focused Spec Detected.",
                    "\(rootURL.path)/Nesting/Nesting.swift:10:9: error: Focused Spec Detected.",
                    "\(rootURL.path)/Nesting/Nesting.swift:10:62: error: Focused Spec Detected.",
                    "\(rootURL.path)/SampleSpec.swift:6:9: error: Focused Spec Detected.",
                    "\(rootURL.path)/SampleSpec.swift:11:9: error: Focused Spec Detected.",
                    "\(rootURL.path)/SampleSpec.swift:16:9: error: Focused Spec Detected.",
                    "\(rootURL.path)/SampleSpec.swift:21:9: error: Focused Spec Detected."
                ]))

                expect { try result.get() }.to(throwError(ExitCode(1)))
            }
        }
    }
}
