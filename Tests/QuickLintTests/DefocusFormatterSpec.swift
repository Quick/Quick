import Fakes
import Quick
import Nimble
import Foundation
@testable import QuickLint

final class DefocusFormatterSpec: AsyncSpec {
    override class func spec() {
        @TestState var detector: FakeFileDetector! = FakeFileDetector()
        @TestState var fileInterface: FakeFileInterface! = FakeFileInterface()

        @TestState var subject: FoundationDefocusFormatter!

        beforeEach {
            subject = .init(detector: detector, fileInterface: fileInterface)
        }

        describe("format(rootUrls:)") {
            let rootUrls = [
                URL(fileURLWithPath: "/a"),
                URL(fileURLWithPath: "/b")
            ]

            @TestState var result: Result<Void, Error>?

            beforeEach {
                detector.filesSpy.stub(success: [])
            }

            justBeforeEach {
                result = await Result {
                    try await subject.format(rootUrls: rootUrls)
                }
            }

            it("asks the detector to search for any swift or objective-c(++) files that have focused specs") {
                expect(detector.filesSpy).to(beCalled(satisfyAllOf(
                    map(\.matching, equal(focusRegexString)),
                    map(\.urls, equal(rootUrls)),
                    map(\.fileExtension, equal(focusFileExtension))
                ), times: 1))
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
            }

            context("when there are matches found") {
                let matches = [
                    RegexMatch(
                        url: URL(fileURLWithPath: "/a"),
                        line: 10,
                        character: 15
                    )
                ]
                beforeEach {
                    detector.filesSpy.stub(success: matches)

                    fileInterface.readSpy.stub(
                        success: """
                        "this line isn't fit for replacing."
                        fit("hello!") {}
                        fitBehavesLike("hello")
                        fitBehavesLike(SomeBehavior.self)
                        fdescribe("something") { fit("nesting!") {}}
                        fcontext("whatever")

                        it("hi") {}
                        xit("hello") {}
                        """
                    )
                }

                it("reads the files found") {
                    expect(fileInterface.readSpy).to(beCalled(URL(fileURLWithPath: "/a")))
                }

                it("replaces all instances of focused specs with unfocused specs and writes that to the file.") {
                    let expectedContents = """
                    "this line isn't fit for replacing."
                    it("hello!") {}
                    itBehavesLike("hello")
                    itBehavesLike(SomeBehavior.self)
                    describe("something") { it("nesting!") {}}
                    context("whatever")

                    it("hi") {}
                    xit("hello") {}
                    """

                    expect(fileInterface.writeSpy).to(beCalled(satisfyAllOf(
                        map(\.contents, equal(expectedContents)),
                        map(\.url, equal(URL(fileURLWithPath: "/a")))
                    )))
                }

                it("doesn't throw an error") {
                    expect { try result?.get() }.to(beVoid())
                }
            }
        }
    }
}
