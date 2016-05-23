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
    public class var focused: String {
        return "focused"
    }

    /**
        Example and example groups with [Excluded: true] are not included in test runs.
        Use this to disable examples that do not pass. Of course, you could also comment
        the examples out altogether, but excluding them will ensure they continue to at
        least compile, which allows them to be re-enabled more easily in the future.
     
        In addition, future versions of Quick may be able to point out when a disabled test
        passes, and thus should be re-enabled.
    */
    public class var excluded: String {
        return "excluded"
    }

    /**
        Like "excluded", example and example groups with [Pending: true] are not included in test runs,
        and so you can use this to temporarily suspend examples that you know do not pass yet.
        "Pending" examples imply that the examples will soon pass, they just need a little more work.
        Functionally, they are no different from "excluded" examples.
    */
    public class var pending: String {
        return "pending"
    }
}
