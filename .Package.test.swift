import PackageDescription

let package = Package(
    name: "Quick",
    targets: {
#if _runtime(_ObjC)
        return [
            Target(name: "QuickSpecBase"),
            Target(name: "Quick", dependencies: [ "QuickSpecBase" ]),
            Target(name: "QuickTests", dependencies: [ "Quick" ]),
        ]
#else
        return [
            Target(name: "Quick"),
            Target(name: "QuickTests", dependencies: [ "Quick" ]),
        ]
#endif
    }(),
    // TODO: Once the `test` command has been implemented in the Swift Package Manager, this should be changed to
    // be `testDependencies:` instead. For now it has to be done like this for the library to get linked with the test targets.
    // See: https://github.com/apple/swift-evolution/blob/master/proposals/0019-package-manager-testing.md
    dependencies: [
        .Package(url: "https://github.com/Quick/Nimble", majorVersion: 6)
    ],
    exclude: {
        var excludes = [
            "Sources/QuickObjectiveC",
            "Tests/QuickTests/QuickAfterSuiteTests/AfterSuiteTests+ObjC.m",
            "Tests/QuickTests/QuickFocusedTests/FocusedTests+ObjC.m",
            "Tests/QuickTests/QuickTests/FunctionalTests/ObjC",
            "Tests/QuickTests/QuickTests/Helpers",
            "Tests/QuickTests/QuickTests/QuickConfigurationTests.m",
        ]
#if !_runtime(_ObjC)
        excludes.append("Sources/QuickSpecBase")
#endif
        return excludes
    }()
)
