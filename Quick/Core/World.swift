//
//  World.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

var _specs: Dictionary<String, ExampleGroup> = [:]
var _currentExampleGroup: ExampleGroup?

var _beforeSuite: (() -> ())[] = []
var _beforeSuiteToken: dispatch_once_t = 0

var _afterSuite: (() -> ())[] = []
var _afterSuiteToken: dispatch_once_t = 0

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
    
    class func runBeforeSpec() {
        dispatch_once(&_beforeSuiteToken) {
            for closure in _beforeSuite {
                closure()
            }
        }
    }

    class func runAfterSpec() {
        dispatch_once(&_afterSuiteToken) {
            for closure in _afterSuite {
                closure()
            }
        }
    }
    
    class func appendBeforeSuite(closure: () -> ()) {
        _beforeSuite.append(closure)
    }

    class func appendAfterSuite(closure: () -> ()) {
        _afterSuite.append(closure)
    }

    class func setCurrentExampleGroup(group: ExampleGroup?) {
        _currentExampleGroup = group
    }

    class func currentExampleGroup() -> ExampleGroup? {
        return _currentExampleGroup
    }
}