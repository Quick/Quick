import Foundation

extension NSBundle {

    internal static var currentTestBundle: NSBundle? {
        return allBundles().lazy
            .filter {
                $0.bundlePath.hasSuffix(".xctest")
            }
            .first
    }

}
