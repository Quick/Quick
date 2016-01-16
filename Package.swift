import PackageDescription

let package = Package(
    name: "Quick",
    targets: [
        Target(name: "QuickTests", dependencies: [.Target(name: "Quick"), .Target(name: "QuickTestHelpers")]),
        Target(name: "QuickFocusedTests", dependencies: [.Target(name: "Quick"), .Target(name: "QuickTestHelpers")]),
        Target(name: "QuickTestHelpers", dependencies: [.Target(name: "Quick")]),
    ],
    dependencies: [ // TODO: This ought to be `testDependencies:` but there seems to be a swiftpm bug causing the lib to not get linked then
        .Package(url: "https://github.com/briancroom/Nimble", majorVersion: 3)
    ]
)
