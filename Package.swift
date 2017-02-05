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
