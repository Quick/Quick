import Quick
import XCTest

QCKMain([
    FunctionalTests_FocusedSpec_Focused.self,
    FunctionalTests_FocusedSpec_Unfocused.self,
],
configurations: [FunctionalTests_FocusedSpec_SharedExamplesConfiguration.self],
testCases: [testCase(FocusedTests.allTests)]
)
