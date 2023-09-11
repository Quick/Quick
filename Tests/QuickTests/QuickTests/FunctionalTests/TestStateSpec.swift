import Quick
import Nimble

class FunctionalTests_TestStateSpec: QuickSpec {
    override class func spec() {
        describe("testState without initial value") {
            @TestState var testState: Int!

            it("starts being nil") {
                expect(testState) == nil
            }

            context("when it's assigned a value") {
                it("should have the value in the test where it was set") {
                    testState = 1234
                    expect(testState) == 1234
                }

                it("should be reset to nil in the following test") {
                    expect(testState) == nil
                }
            }
        }

        describe("testState with initial wrapped value") {
            @TestState var testState = 9876
            var beforeEachValue: Int?
            var afterEachValue: Int?

            beforeEach {
                beforeEachValue = testState
            }

            afterEach {
                afterEachValue = testState
            }

            it("should be set in beforeEach") {
                expect(beforeEachValue) == testState
            }

            it("should have a value in afterEach") {
                expect(afterEachValue) == testState
            }

            it("starts with the initial value") {
                expect(testState) == 9876
            }

            context("when it's assigned a value") {
                it("should have the value in the test where it was set") {
                    testState = 1234
                    expect(testState) == 1234
                }

                it("should be reset to the initial in the following test") {
                    expect(testState) == 9876
                }
            }
        }

        describe("testState with an initial value") {
            @TestState(9876) var testState: Int!
            var beforeEachValue: Int?
            var afterEachValue: Int?

            beforeEach {
                beforeEachValue = testState
            }

            afterEach {
                afterEachValue = testState
            }

            it("should be set in beforeEach") {
                expect(beforeEachValue) == testState
            }

            it("should have a value in afterEach") {
                expect(afterEachValue) == testState
            }

            it("starts with the initial value") {
                expect(testState) == 9876
            }

            context("when it's assigned a value") {
                it("should have the value in the test where it was set") {
                    testState = 1234
                    expect(testState) == 1234
                }

                it("should be reset to the initial in the following test") {
                    expect(testState) == 9876
                }
            }
        }
    }
}

class FunctionalTests_TestStateAsyncSpec: AsyncSpec {
    override class func spec() {
        describe("testState without initial value") {
            @TestState var testState: Int!

            it("starts being nil") {
                expect(testState) == nil
            }

            context("when it's assigned a value") {
                it("should have the value in the test where it was set") {
                    testState = 1234
                    expect(testState) == 1234
                }

                it("should be reset to nil in the following test") {
                    expect(testState) == nil
                }
            }
        }

        describe("testState with initial wrapped value") {
            @TestState var testState = 9876
            var beforeEachValue: Int?
            var afterEachValue: Int?

            beforeEach {
                beforeEachValue = testState
            }

            afterEach {
                afterEachValue = testState
            }

            it("should be set in beforeEach") {
                expect(beforeEachValue) == testState
            }

            it("should have a value in afterEach") {
                expect(afterEachValue) == testState
            }

            it("starts with the initial value") {
                expect(testState) == 9876
            }

            context("when it's assigned a value") {
                it("should have the value in the test where it was set") {
                    testState = 1234
                    expect(testState) == 1234
                }

                it("should be reset to the initial in the following test") {
                    expect(testState) == 9876
                }
            }
        }

        describe("testState with an initial value") {
            @TestState(9876) var testState: Int!
            var beforeEachValue: Int?
            var afterEachValue: Int?

            beforeEach {
                beforeEachValue = testState
            }

            afterEach {
                afterEachValue = testState
            }

            it("should be set in beforeEach") {
                expect(beforeEachValue) == testState
            }

            it("should have a value in afterEach") {
                expect(afterEachValue) == testState
            }

            it("starts with the initial value") {
                expect(testState) == 9876
            }

            context("when it's assigned a value") {
                it("should have the value in the test where it was set") {
                    testState = 1234
                    expect(testState) == 1234
                }

                it("should be reset to the initial in the following test") {
                    expect(testState) == 9876
                }
            }
        }
    }
}
