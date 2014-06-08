//
//  World.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

let QCKExampleGroupsKey = "QCKExampleGroupsKey"

var _specs: Dictionary<String, ExampleGroup> = [:]
var _currentExampleGroup: ExampleGroup?
var _currentExample: Example?

@objc class World {
    class func rootExampleGroupForSpecClass(cls: AnyClass) -> ExampleGroup {
        let name = NSStringFromClass(cls)
        if let group = _specs[name] {
            return group
        } else {
            let group = ExampleGroup("root example group")
            _specs[name] = group
            return group
        }
    }

    class func setCurrentExampleGroup(group: ExampleGroup?) {
        _currentExampleGroup = group
    }

    class func currentExampleGroup() -> ExampleGroup? {
        return _currentExampleGroup
    }

    class var currentExample: Example? {
        get { return _currentExample }
        set { _currentExample = newValue }
    }
}