//
//  Actual.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

class Actual {
    let actual: NSObject
    init(_ actual: NSObject) {
        self.actual = actual
    }
    
    var to: Target { get { return Target(actual) } }
}

class Target {
    let actual: NSObject
    init(_ actual: NSObject) {
        self.actual = actual
    }
}
