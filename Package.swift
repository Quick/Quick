import PackageDescription

let package = Package(
    name: "Quick",
    exclude: [
      "Sources/QuickObjectiveC",
      "Tests/QuickTests/QuickAfterSuiteTests/AfterSuiteTests+ObjC.m",
      "Tests/QuickTests/QuickFocusedTests/FocusedTests+ObjC.m",
      "Tests/QuickTests/QuickTests/FunctionalTests/ObjC",
      "Tests/QuickTests/QuickTests/Helpers",
      "Tests/QuickTests/QuickTests/QuickConfigurationTests.m",
    ]
)
