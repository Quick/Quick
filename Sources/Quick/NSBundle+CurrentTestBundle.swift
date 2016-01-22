#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)

import Foundation

extension NSBundle {

    /**
     Locates the first bundle with a '.xctest' file extension.
     */
    internal static var currentTestBundle: NSBundle? {
        return allBundles().lazy
            .filter {
                $0.bundlePath.hasSuffix(".xctest")
            }
            .first
    }

}

#endif
