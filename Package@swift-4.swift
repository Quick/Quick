// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Quick",
    products: [
        .executable(name: "qck", targets: ["qck"]),
        .library(name: "Quick", targets: ["Quick"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/Commander.git", from: "0.6.0"),
        .package(url: "https://github.com/kylef/PathKit.git", from: "0.8.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "7.0.1"),
    ],
    targets: {
        var targets: [Target] = [
            .target(
                name: "qck",
                dependencies: [
                    "Commander",
                    "Cpaths",
                    "PathKit",
                ]
            ),
            .target(name: "Cpaths", dependencies: []),
            .testTarget(
                name: "QuickTests",
                dependencies: [ "Quick", "Nimble" ],
                exclude: [
                    "QuickAfterSuiteTests/AfterSuiteTests+ObjC.m",
                    "QuickFocusedTests/FocusedTests+ObjC.m",
                    "QuickTests/FunctionalTests/ObjC",
                    "QuickTests/Helpers",
                    "QuickTests/QuickConfigurationTests.m",
                ]
            ),
        ]
#if _runtime(_ObjC)
        targets.append(contentsOf: [
            .target(name: "QuickSpecBase", dependencies: []),
            .target(name: "Quick", dependencies: [ "QuickSpecBase" ]),
        ])
#else
        targets.append(contentsOf: [
            .target(name: "Quick", dependencies: []),
        ])
#endif
        return targets
    }(),
    swiftLanguageVersions: [3]
)
