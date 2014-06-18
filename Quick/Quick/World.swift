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
var _beforeSuiteNotRunYet = true

var _afterSuite: (() -> ())[] = []
var _afterSuiteNotRunYet = true

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
        assert(_beforeSuiteNotRunYet, "runBeforeSuite was called twice")
        for closure in _beforeSuite {
            closure()
        }
        _beforeSuiteNotRunYet = false
    }

    class func runAfterSpec() {
        assert(_afterSuiteNotRunYet, "runAfterSuite was called twice")
        for closure in _afterSuite {
            closure()
        }
        _afterSuiteNotRunYet = false
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

    class var exampleCount: Int {
        get {
            var count = 0
            for (_, group) in _specs {
                group.walkDownExamples { (example: Example) -> () in
                    _ = ++count
                }
            }
            return count
        }
    }
}