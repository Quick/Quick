//
//  World.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

class World: NSObject {
    var _specs: Dictionary<String, ExampleGroup> = [:]

    var _beforeSuites: (() -> ())[] = []
    var _beforeSuitesNotRunYet = true

    var _afterSuites: (() -> ())[] = []
    var _afterSuitesNotRunYet = true

    var _sharedExamples: Dictionary<String, () -> ()> = [:]

    var currentExampleGroup: ExampleGroup?

    struct _Shared {
        static let instance = World()
    }
    class func sharedWorld() -> World {
        return _Shared.instance
    }

    func rootExampleGroupForSpecClass(cls: AnyClass) -> ExampleGroup {
        let name = NSStringFromClass(cls)
        if let group = _specs[name] {
            return group
        } else {
            let group = ExampleGroup("root example group")
            _specs[name] = group
            return group
        }
    }

    func runBeforeSpec() {
        assert(_beforeSuitesNotRunYet, "runBeforeSuite was called twice")
        for beforeSuite in _beforeSuites {
            beforeSuite()
        }
        _beforeSuitesNotRunYet = false
    }

    func runAfterSpec() {
        assert(_afterSuitesNotRunYet, "runAfterSuite was called twice")
        for afterSuite in _afterSuites {
            afterSuite()
        }
        _afterSuitesNotRunYet = false
    }

    func appendBeforeSuite(closure: () -> ()) {
        _beforeSuites.append(closure)
    }

    func appendAfterSuite(closure: () -> ()) {
        _afterSuites.append(closure)
    }

    var exampleCount: Int {
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

    func registerSharedExample(name: String, closure: () -> ()) {
        _raiseIfSharedExampleAlreadyRegistered(name)
        _sharedExamples[name] = closure
    }

    func _raiseIfSharedExampleAlreadyRegistered(name: String) {
        if _sharedExamples[name] != nil {
            NSException(name: NSInternalInconsistencyException,
                reason: "A shared example named '\(name)' has already been registered.",
                userInfo: nil).raise()
        }
    }

    func sharedExample(name: String) -> (() -> ()) {
        _raiseIfSharedExampleNotRegistered(name)
        return _sharedExamples[name]!
    }

    func _raiseIfSharedExampleNotRegistered(name: String) {
        if _sharedExamples[name] == nil {
            NSException(name: NSInternalInconsistencyException,
                reason: "No shared example named '\(name)' has been registered. Registered shared examples: '\(_sharedExamples.keys)'",
                userInfo: nil).raise()
        }
    }
}
