import Foundation

#if os(Linux)
    extension NSURL {
        internal var deletingPathExtension: NSURL? {
            return URLByDeletingPathExtension
        }
    }
#endif
