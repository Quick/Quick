import Fakes
import Quick
import Nimble
import Foundation
@testable import QuickLint

final class LintCommandSpec: AsyncSpec {
    override class func spec() {
        let rootURL = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("LintFixtures")

        it("finds and lints focused specs") {
            var subject = LintCommand()
            subject.paths = [rootURL.path]
            subject.error = false

            let writer = FakeWriter()

            subject.dependencies.writer = writer

            try await subject.run()

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
        }
    }
}
