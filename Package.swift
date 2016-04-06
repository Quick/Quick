import PackageDescription

let package = Package(
    name: "Quick",
    // TODO: Once the `test` command has been implemented in the Swift Package Manager, this should be changed to
    // be `testDependencies:` instead. For now it has to be done like this for the library to get linked with the test targets.
    // See: https://github.com/apple/swift-evolution/blob/master/proposals/0019-package-manager-testing.md
    dependencies: [
        .Package(url: "https://github.com/norio-nomura/Nimble", majorVersion: 3)
    ]
)
