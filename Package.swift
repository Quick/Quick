// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Quick",
    platforms: [
        .macOS(.v10_10), .iOS(.v9), .tvOS(.v9)
    ],
    products: [
        .library(name: "Quick", targets: ["Quick"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Nimble.git", from: "9.1.0"),
    ],
    targets: {
        var targets: [Target] = [
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
        ]
#if os(macOS)
        targets.append(contentsOf: [
            .target(name: "QuickObjCRuntime", dependencies: []),
            .target(
                name: "Quick",
                dependencies: [ "QuickObjCRuntime" ],
                exclude: [
                    "Info.plist",
                ]
            ),
        ])
#else
        targets.append(contentsOf: [
            .target(name: "Quick", dependencies: []),
        ])
#endif
        return targets
    }(),
    swiftLanguageVersions: [.v5]
)
