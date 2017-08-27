import Foundation

/**
    A class that encapsulates information about an example,
    including the index at which the example was executed, as
    well as the example itself.
*/
final public class ExampleMetadata: NSObject {
    /**
        The example for which this metadata was collected.
    */
    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && !SWIFT_PACKAGE
    @objc
    public let example: Example
    #else
    public let example: Example
    #endif

    /**
        The index at which this example was executed in the
        test suite.
    */
    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && !SWIFT_PACKAGE
    @objc
    public let exampleIndex: Int
    #else
    public let exampleIndex: Int
    #endif

    internal init(example: Example, exampleIndex: Int) {
        self.example = example
        self.exampleIndex = exampleIndex
    }
}
