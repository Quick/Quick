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

/// Retrieves the current list of all known classes that are a subtype of the desired type.
/// This uses `objc_copyClassList` instead of `objc_getClassList` because the get function
/// is subject to race conditions and buffer overflow issues. The copy function handles all of that for us.
private func allSubclasses<T: AnyObject>(ofType targetType: T.Type) -> [T.Type] {
    // See https://developer.apple.com/forums/thread/700770.
    var classesCount: UInt32 = 0
    guard let classList = objc_copyClassList(&classesCount) else { return [] }
    defer { free(UnsafeMutableRawPointer(classList)) }
    let classes = UnsafeBufferPointer(start: classList, count: Int(classesCount))

    guard classesCount > 0 else {
        return []
    }

    return classes.filter { isClass($0, aSubclassOf: targetType) }
        .compactMap { $0 as? T.Type }
}

/// Detects all subclasses of the given type, and calls the given block with each of them.
/// The classes are iterated over in the order that `objc_copyClassList` returns them.
///
/// - parameter givenSubclasses: A list of given subclasses. If non-nil, these will be iterated over instead of the given subclasses.
/// - parameter block: A block that takes the given type.
///                    This block will be executed once for each subclass of that type.
func enumerateSubclasses<T: AnyObject>(givenSubclasses: [T.Type]? = nil, _ block: (T.Type) -> Void) {
    (givenSubclasses ?? allSubclasses(ofType: T.self))
        .forEach(block)
}

#endif
