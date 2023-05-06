#if canImport(Darwin)
import Foundation

@objc internal final class TestSelectorNameProvider: NSObject {
    @objc static func testSelectorName(for example: Example, classSelectorNames selectorNames: Set<String>) -> String {
        if useLegacyStyleTestSelectorNames {
            return legacyStyleTestSelectorName(exampleName: example.name, classSelectorNames: selectorNames, isAsync: false)
        } else {
            return humanReadableTestSelectorName(exampleName: example.name, classSelectorNames: selectorNames)
        }
    }

    static func testSelectorName(forAsync example: AsyncExample, classSelectorNames selectorNames: Set<String>) -> String {
        if useLegacyStyleTestSelectorNames {
            return legacyStyleTestSelectorName(exampleName: example.name, classSelectorNames: selectorNames, isAsync: true)
        } else {
            return humanReadableTestSelectorName(exampleName: example.name, classSelectorNames: selectorNames)
        }
    }

    internal static var useLegacyStyleTestSelectorNames: Bool = {
        ProcessInfo.processInfo.environment["QUICK_USE_ENCODED_TEST_SELECTOR_NAMES"] != nil
    }()

    private static func legacyStyleTestSelectorName(exampleName: String, classSelectorNames selectorNames: Set<String>, isAsync: Bool) -> String {
        let originalName = exampleName.c99ExtendedIdentifier
        var selectorName = originalName
        var index: UInt = 2

        var proposedName = isAsync ? selectorName.appending(":") : selectorName

        while selectorNames.contains(proposedName) {
            selectorName = String(format: "%@_%tu", originalName, index)
            proposedName = isAsync ? selectorName.appending(":") : selectorName
            index += 1
        }

        return proposedName
    }

    private static func humanReadableTestSelectorName(exampleName: String, classSelectorNames selectorNames: Set<String>) -> String {
        var selectorName = exampleName
        var index: UInt = 2

        while selectorNames.contains(selectorName) {
            selectorName = String(format: "%@ (%tu)", exampleName, index)
            index += 1
        }
        return selectorName
    }
}
#endif
