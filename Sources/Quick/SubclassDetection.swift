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
