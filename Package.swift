import PackageDescription

let package = Package(
    name: "Quick",
    targets: [
        Target(name: "QuickTests", dependencies: [.Target(name: "Quick"), .Target(name: "QuickTestHelpers")]),
        Target(name: "QuickFocusedTests", dependencies: [.Target(name: "Quick"), .Target(name: "QuickTestHelpers")]),
        Target(name: "QuickTestHelpers", dependencies: [.Target(name: "Quick")]),
    ],
    // TODO: Once the `test` command has been implemented in the Swift Package Manager, this should be changed to
    // be `testDependencies:` instead. For now it has to be done like this for the library to get linked with the test targets.
    // See: https://github.com/apple/swift-evolution/blob/master/proposals/0019-package-manager-testing.md
    dependencies: [ 
        .Package(url: "https://github.com/briancroom/Nimble", majorVersion: 3)
    ]
)
