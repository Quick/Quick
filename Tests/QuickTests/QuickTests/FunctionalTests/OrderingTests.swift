import Quick
import Nimble

class OrderingTests: QuickSpec {
    override class func spec() {
        describe("Running a set of tests exactly in the order that they're written") {
            var testRunCount = 0

            it("b should run this one first") {
                testRunCount += 1
                expect(testRunCount).to(equal(1))
            }

            it("z should run this one second") {
                testRunCount += 1
                expect(testRunCount).to(equal(2))
            }

            it("e should run this one third") {
                testRunCount += 1
                expect(testRunCount).to(equal(3))
            }

            it("a should run this one fourth") {
                testRunCount += 1
                expect(testRunCount).to(equal(4))
            }

            describe("h even handles describes") {
                it("c should run this one fifth") {
                    testRunCount += 1
                    expect(testRunCount).to(equal(5))
                }

                it("j should run this one sixth") {
                    testRunCount += 1
                    expect(testRunCount).to(equal(6))
                }
            }

            it("d should run this one seventh") {
                testRunCount += 1
                expect(testRunCount).to(equal(7))
            }

            describe("k more describes don't break it") {
                it("c should run this one eighth") {
                    testRunCount += 1
                    expect(testRunCount).to(equal(8))
                }

                it("j should run this one ninth") {
                    testRunCount += 1
                    expect(testRunCount).to(equal(9))
                }
            }

            context("n works for contexts too") {
                it("c should run this one tenth") {
                    testRunCount += 1
                    expect(testRunCount).to(equal(10))
                }

                it("j should run this one eleventh") {
                    testRunCount += 1
                    expect(testRunCount).to(equal(11))
                }
            }
        }
    }
}
