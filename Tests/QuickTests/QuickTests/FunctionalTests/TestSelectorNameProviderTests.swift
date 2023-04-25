#if canImport(Darwin)
import Nimble
import XCTest
@testable import Quick

final class TestSelectorNameProviderTests: XCTestCase {
    let example = Example(description: "doesn't do the incorrect behavior 🤪", callsite: Callsite(file: #file, line: #line), flags: [:], closure: {})
    let asyncExample = AsyncExample(description: "doesn't do the incorrect behavior 🤨, but async!", callsite: Callsite(file: #file, line: #line), flags: [:], closure: {})

    var originalUseLegacyStyleTestNames: Bool = false

    override func setUp() {
        self.originalUseLegacyStyleTestNames = TestSelectorNameProvider.useLegacyStyleTestSelectorNames
    }

    override func tearDown() {
        TestSelectorNameProvider.useLegacyStyleTestSelectorNames = originalUseLegacyStyleTestNames
    }

    // MARK: - Sync Examples
    func testWithExampleAndHumanReadableCreatesHumanReadableTestSelectors() {
        expect(TestSelectorNameProvider.testSelectorName(for: self.example, classSelectorNames: [])).to(equal("doesn't do the incorrect behavior 🤪"))
    }

    func testWithExampleAndHumanReadableDoesntAllowDuplicateSelectors() {
        expect(TestSelectorNameProvider.testSelectorName(for: self.example, classSelectorNames: ["doesn't do the incorrect behavior 🤪"])).to(equal("doesn't do the incorrect behavior 🤪 (2)"))
    }

    func testWithExampleAndLegacyCreatesLegacyTestSelectors() {
        TestSelectorNameProvider.useLegacyStyleTestSelectorNames = true

        expect(TestSelectorNameProvider.testSelectorName(for: self.example, classSelectorNames: [])).to(equal("doesn_t_do_the_incorrect_behavior__"))
    }

    func testWithExampleAndLegacyDoesntAllowDuplicateSelectors() {
        TestSelectorNameProvider.useLegacyStyleTestSelectorNames = true

        expect(TestSelectorNameProvider.testSelectorName(for: self.example, classSelectorNames: ["doesn_t_do_the_incorrect_behavior__"])).to(equal("doesn_t_do_the_incorrect_behavior___2"))
    }

    // MARK: - Async Examples
    func testWithAsyncExampleAndHumanReadableCreatesHumanReadableTestSelectors() {
        expect(TestSelectorNameProvider.testSelectorName(forAsync: self.asyncExample, classSelectorNames: [])).to(equal("doesn't do the incorrect behavior 🤨, but async!"))
    }

    func testWithAsyncExampleAndHumanReadableDoesntAllowDuplicateSelectors() {
        expect(TestSelectorNameProvider.testSelectorName(forAsync: self.asyncExample, classSelectorNames: ["doesn't do the incorrect behavior 🤨, but async!"])).to(equal("doesn't do the incorrect behavior 🤨, but async! (2)"))
    }

    func testWithAsyncExampleAndLegacyCreatesLegacyTestSelectors() {
        TestSelectorNameProvider.useLegacyStyleTestSelectorNames = true

        expect(TestSelectorNameProvider.testSelectorName(forAsync: self.asyncExample, classSelectorNames: [])).to(equal("doesn_t_do_the_incorrect_behavior____but_async_:"))
    }

    func testWithAsyncExampleAndLegacyDoesntAllowDuplicateSelectors() {
        TestSelectorNameProvider.useLegacyStyleTestSelectorNames = true

        expect(TestSelectorNameProvider.testSelectorName(forAsync: self.asyncExample, classSelectorNames: ["doesn_t_do_the_incorrect_behavior____but_async_:"])).to(equal("doesn_t_do_the_incorrect_behavior____but_async__2:"))
    }
}
#endif
