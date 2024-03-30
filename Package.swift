// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Quick",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13)
    ],
    products: [
        .library(name: "Quick", targets: ["Quick"]),
        .executable(name: "QuickLint", targets: ["QuickLint"]),
        .plugin(name: "QuickDefocusCommandPlugin", targets: ["DefocusCommandPlugin"]),
        .plugin(name: "QuickLintBuildToolPlugin", targets: ["LintBuildToolPlugin"]),
        .plugin(name: "QuickLintCommandPlugin", targets: ["LintCommandPlugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Nimble.git", from: "13.2.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.1"),
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.2.0"),
        .package(url: "https://github.com/Quick/swift-fakes.git", from: "0.0.1"),
    ],
    targets: {
        var targets: [Target] = [
            .plugin(
                name: "DefocusCommandPlugin",
                capability: .command(intent: .custom(verb: "defocus", description: "Remove focus from Quick examples"), permissions: [.writeToPackageDirectory(reason: "Remove focus from Quick examples")]),
                dependencies: ["QuickLint"]
            ),
            .plugin(
                name: "LintBuildToolPlugin",
                capability: .buildTool(),
                dependencies: ["QuickLint"]
            ),
            .plugin(
                name: "LintCommandPlugin",
                capability: .command(intent: .custom(verb: "quicklint", description: "Verify no focused tests in Quick tests"), permissions: []),
                dependencies: ["QuickLint"]
            ),
            .executableTarget(
                name: "QuickLint",
                dependencies: [
                    .product(name: "ArgumentParser", package: "swift-argument-parser"),
                    .product(name: "Algorithms", package: "swift-algorithms"),
                ]
            ),
            .testTarget(
                name: "QuickTests",
                dependencies: [ "Quick", "Nimble" ],
                exclude: [
                    "QuickAfterSuiteTests/AfterSuiteTests+ObjC.m",
                    "QuickFocusedTests/FocusedTests+ObjC.m",
                    "QuickTests/FunctionalTests/ObjC",
                    "QuickTests/Helpers/QCKSpecRunner.h",
                    "QuickTests/Helpers/QCKSpecRunner.m",
                    "QuickTests/Helpers/QuickTestsBridgingHeader.h",
                    "QuickTests/QuickConfigurationTests.m",
                    "QuickFocusedTests/Info.plist",
                    "QuickTests/Info.plist",
                    "QuickAfterSuiteTests/Info.plist",
                ]
            ),
            .testTarget(
                name: "QuickIssue853RegressionTests",
                dependencies: [ "Quick" ]
            ),
            .testTarget(
                name: "QuickLintTests",
                dependencies: [
                    "QuickLint",
                    "Quick",
                    "Nimble",
                    .product(name: "Fakes", package: "swift-fakes"),
                ]
            )
        ]
#if os(macOS)
        targets.append(contentsOf: [
            .target(name: "QuickObjCRuntime", dependencies: []),
            .target(
                name: "Quick",
                dependencies: [ "QuickObjCRuntime" ],
                exclude: [
                    "Info.plist",
                ],
                resources: [
                    .copy("PrivacyInfo.xcprivacy")
                ]
            ),
        ])
#else
        targets.append(contentsOf: [
            .target(
                name: "Quick",
                dependencies: [],
                exclude: [
                    "Info.plist"
                ],
                resources: [
                    .copy("PrivacyInfo.xcprivacy")
                ]
            ),
        ])
#endif
        return targets
    }(),
    swiftLanguageVersions: [.v5]
)
