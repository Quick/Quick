import Foundation

/**
    A mapping of string keys to booleans that can be used to
    filter examples or example groups. For example, a "focused"
    example would have the flags [Focused: true].
*/
public typealias FilterFlags = [String: Bool]

/**
    A namespace for filter flag keys, defined primarily to make the
    keys available in Objective-C.
*/
final public class Filter: NSObject {
    /**
        Example and example groups with [Focused: true] are included in test runs,
        excluding all other examples without this flag. Use this to only run one or
        two tests that you're currently focusing on.
    */
    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && !SWIFT_PACKAGE
    @objc
    public class var focused: String { return "focused" }
    #else
    public class var focused: String { return "focused" }
    #endif

    /**
        Example and example groups with [Pending: true] are excluded from test runs.
        Use this to temporarily suspend examples that you know do not pass yet.
    */
    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && !SWIFT_PACKAGE
    @objc
    public class var pending: String { return "pending" }
    #else
    public class var pending: String { return "pending" }
    #endif
}
