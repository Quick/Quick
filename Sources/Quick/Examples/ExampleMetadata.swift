import Foundation

#if canImport(Darwin)
// swiftlint:disable type_name
@objcMembers
public class _ExampleMetadataBase: NSObject {}
#else
public class _ExampleMetadataBase: NSObject {}
// swiftlint:enable type_name
#endif

/**
    A class that encapsulates information about an example,
    including the index at which the example was executed, as
    well as the example itself.
*/
public class ExampleMetadata: _ExampleMetadataBase {
    /**
        The example for which this metadata was collected.
    */
    public let example: ExampleBase

    /**
        The index at which this example was executed in the
        test suite.
    */
    public let exampleIndex: Int

    fileprivate init(example: ExampleBase, exampleIndex: Int) {
        self.example = example
        self.exampleIndex = exampleIndex
    }
}

final class SyncExampleMetadata: ExampleMetadata {
    let group: ExampleGroup

    init(group: ExampleGroup, example: ExampleBase, exampleIndex: Int) {
        self.group = group
        super.init(example: example, exampleIndex: exampleIndex)
    }
}

final class AsyncExampleMetadata: ExampleMetadata {
    let group: AsyncExampleGroup

    init(group: AsyncExampleGroup, example: ExampleBase, exampleIndex: Int) {
        self.group = group
        super.init(example: example, exampleIndex: exampleIndex)
    }
}
