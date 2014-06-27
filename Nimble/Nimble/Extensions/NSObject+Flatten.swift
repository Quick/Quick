//
//  NSObject+Flatten.swift
//  Nimble
//
//  Created by Brian Ivan Gesiak on 6/27/14.
//
//

import Foundation

extension NSObject {
    func nmb_flatten() -> String {
        func join(array: NSArray) -> String {
            return "[ " + array.componentsJoinedByString(", ") + " ]"
        }

        switch self {
        case let array as NSArray: return join(array)
        case let set as NSSet: return join(set.allObjects)
        default: return "\(self)"
        }
    }
}
