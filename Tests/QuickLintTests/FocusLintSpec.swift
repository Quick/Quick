import Fakes
import Quick
import Nimble
import Foundation
@testable import QuickLint

final class FocusLintSpec: AsyncSpec {
    override class func spec() {
        @TestState var subject: XcodeFocusLint!
        @TestState var detector: FakeFileDetector! = FakeFileDetector()
        @TestState var writer: FakeWriter! = FakeWriter()

        beforeEach {
            subject = XcodeFocusLint(detector: detector, output: writer)
        }

        describe("lines(urls:errorOnIssues:)") {
            let urls = [
                URL(fileURLWithPath: "/invalid"),
                URL(fileURLWithPath: "/nonexistent"),
            ]
            var errorOnIssues = false
            @TestState var result: Result<Void, Error>?

            beforeEach {
                errorOnIssues = false
                detector.filesSpy.stub(success: [])
            }

            justBeforeEach {
                result = await Result {
                    try await subject.lint(
                        urls: urls,
                        errorOnIssues: errorOnIssues
                    )
                }
            }

            it("asks the detector to search for any swift or objective-c(++) files that have focused specs") {
                expect(detector.filesSpy).to(beCalled(satisfyAllOf(
                    map(\.matching, equal(focusRegexString)),
                    map(\.urls, equal(urls)),
                    map(\.fileExtension, equal(focusFileExtension))
                ), times: 1))
            }

            context("when no matches are found") {
                beforeEach {
                    detector.filesSpy.stub(success: [])
                }

                it("doesn't output anything") {
                    expect(writer.stderrSpy).toNot(beCalled())
                }
            }

            context("when the detector throws an error") {
                enum TestError: Error {
                    case ohNo
                }

                beforeEach {
                    detector.filesSpy.stub(failure: TestError.ohNo)
                }

                it("throws the error") {
                    expect { try result?.get() }.to(throwError(TestError.ohNo))
                }

                it("doesn't output anything") {
                    expect(writer.stderrSpy).toNot(beCalled())
                }
            }

            context("when there are matches found") {
                let matches = [
                    RegexMatch(
                        url: URL(fileURLWithPath: "/a"),
                        line: 10,
                        character: 15
                    ),
                    RegexMatch(
                        url: URL(fileURLWithPath: "/b"),
                        line: 5,
                        character: 2
                    ),
                ]
                beforeEach {
                    detector.filesSpy.stub(success: matches)
                }

                context("and errorOnIssues is true") {
                    beforeEach {
                        errorOnIssues = true
                    }

                    it("converts the results to xcode-compatible strings, noting that these are errors") {
                        expect(writer.stderrSpy).to(beCalled(
                            [
                                "/a:10:15: error: Focused Spec Detected.",
                                "/b:5:2: error: Focused Spec Detected.",
                            ],
                            times: 1
                        ))
                    }

                    it("doesn't throw an error") {
                        expect { try result?.get() }.to(beVoid())
                    }
                }

                context("and errorOnIssues is false") {
                    beforeEach {
                        errorOnIssues = false
                    }

                    it("converts the results to xcode-compatible strings, noting that these are just warnings") {
                        expect(writer.stderrSpy).to(beCalled(
                            [
                                "/a:10:15: warning: Focused Spec Detected.",
                                "/b:5:2: warning: Focused Spec Detected.",
                            ],
                            times: 1
                        ))
                    }

                    it("doesn't throw an error") {
                        expect { try result?.get() }.to(beVoid())
                    }
                }
            }
        }
    }
}
