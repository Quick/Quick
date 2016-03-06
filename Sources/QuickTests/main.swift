import Quick
import XCTest

QCKMain([
    FunctionalTests_AfterEachSpec.self,
    FunctionalTests_AfterSuite_AfterSuiteSpec.self,
    FunctionalTests_AfterSuite_Spec.self,
    FunctionalTests_BeforeEachSpec.self,
    FunctionalTests_BeforeSuite_BeforeSuiteSpec.self,
    FunctionalTests_BeforeSuite_Spec.self,
    FunctionalTests_ItSpec.self,
    FunctionalTests_PendingSpec.self,
    FunctionalTests_SharedExamples_BeforeEachSpec.self,
    FunctionalTests_SharedExamples_Spec.self,
    FunctionalTests_SharedExamples_ContextSpec.self,
    Configuration_AfterEachSpec.self,
    Configuration_BeforeEachSpec.self,
],
configurations: [
    FunctionalTests_SharedExamples_BeforeEachTests_SharedExamples.self,
    FunctionalTests_SharedExamplesTests_SharedExamples.self,
    FunctionalTests_Configuration_AfterEach.self,
    FunctionalTests_Configuration_BeforeEach.self,
],
testCases: [
    testCase(AfterEachTests.allTests),
    testCase(AfterSuiteTests.allTests),
    testCase(BeforeEachTests.allTests),
    testCase(BeforeSuiteTests.allTests),
    // testCase(DescribeTests.allTests),
    testCase(ItTests.allTests),
    testCase(PendingTests.allTests),
    testCase(SharedExamples_BeforeEachTests.allTests),
    testCase(SharedExamplesTests.allTests),
    testCase(Configuration_AfterEachTests.allTests),
    testCase(Configuration_BeforeEachTests.allTests),
])
