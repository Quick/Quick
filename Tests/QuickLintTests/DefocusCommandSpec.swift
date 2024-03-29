import Quick
import Nimble
import Foundation
@testable import QuickLint

final class DefocusCommandSpec: AsyncSpec {
    override class func spec() {
        let testRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        let lintFixtures = testRoot
            .appendingPathComponent("LintFixtures")
        let backupFixtures = testRoot
            .appendingPathComponent("lintFixtureBackup")

        beforeEach {
            try FileManager.default.copyItem(at: lintFixtures, to: backupFixtures)
        }

        afterEach {
            try FileManager.default.removeItem(at: backupFixtures)
        }

        it("finds and defocuses focused specs") {
            var subject = DefocusCommand()
            subject.paths = [backupFixtures.path]

            try await subject.run()

            expect {
                try String(
                    contentsOf: backupFixtures
                        .appendingPathComponent("SampleSpec.swift")
                )
            }.to(equal(expectedSampleSpec))

            expect {
                try String(
                    contentsOf: backupFixtures
                        .appendingPathComponent("Nesting")
                        .appendingPathComponent("Nesting.swift")
                )
            }.to(equal(expectedNestingSpec))
        }
    }
}

let expectedSampleSpec = """
import Quick

final class SampleSpec: QuickSpec {
    override class func spec() {
        // context
        context("focused context") {}
        context("unfocused context") {}
        xcontext("pending context") {}

        // describe
        describe("focused describe") {}
        describe("unfocused describe") {}
        xdescribe("pending describe") {}

        // itBehavesLike
        itBehavesLike("") {}
        itBehavesLike("") {}
        xitBehavesLike("") {}

        // it
        it("focused it") {}
        it("unfocused it") {}
        xit("pending it") {}

        // pending
        pending("just pending. Which is treated internally like pending it.") {}
    }
}

"""

let expectedNestingSpec = """
import Quick

// This also checks nesting, and the directory structure is set up to make sure it also checks nested files as well.
final class Nesting: QuickSpec {
    override class func spec() {
        describe("a focused example group") {
            it("still identifies focused examples later on") {}
        }

        context("with multiple focuses on the same line") { it("still identifies the focusing!") {} } // swiftlint:disable:this line_length
    }
}

"""
