#if canImport(Darwin)

import Foundation

/// Determines if a class is a subclass of another by looping over the superclasses of the given class.
/// Apparently, `isSubclass(of:)` uses a different method to check this, which can cause exceptions to
/// be raised under certain circumstances when used in conjuction with `objc_getClassList`.
/// See https://github.com/Quick/Quick/issues/1155, and https://openradar.appspot.com/FB9854851.
func isClass(_ klass: AnyClass, aSubclassOf targetClass: AnyClass) -> Bool {
    var superclass: AnyClass? = klass
    while superclass != nil {
        superclass = class_getSuperclass(superclass)
        if superclass == targetClass { return true }
    }
    return false
}
#endif

/// Retrieves the current list of all known classes that are a subtype of the desired type.
/// This uses `objc_copyClassList` instead of `objc_getClassList` because the get function
/// is subject to race conditions and buffer overflow issues. The copy function handles all of that for us.
/// Note: On non-Apple platforms, this will return an empty array.
func allSubclasses<T: AnyObject>(ofType targetType: T.Type) -> [T.Type] {
    #if canImport(Darwin)
    // See https://developer.apple.com/forums/thread/700770.
    var classesCount: UInt32 = 0
    guard let classList = objc_copyClassList(&classesCount) else { return [] }
    defer { free(UnsafeMutableRawPointer(classList)) }
    let classes = UnsafeBufferPointer(start: classList, count: Int(classesCount))

    guard classesCount > 0 else {
        return []
    }

    return classes.filter { isClass($0, aSubclassOf: targetType) }
        // swiftlint:disable:next force_cast
        .map { $0 as! T.Type }
    #else
    return []
    #endif
}
