#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)

import Foundation

extension Bundle {

    /**
     Locates the first bundle with a '.xctest' file extension.
     */
    internal static var currentTestBundle: Bundle? {
        return allBundles.first { $0.bundlePath.hasSuffix(".xctest") }
    }

}

#endif
