import Foundation

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
@objc public enum Order: Int {
    case random
    case defined
}
#else
public enum Order: Int {
    case random
    case defined
}
#endif
