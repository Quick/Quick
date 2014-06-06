//
//  Matcher.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

class Matcher {
    let expected: NSObject
    init(_ expected: NSObject) {
        self.expected = expected
    }
    
    func match(actual: NSObject) {
        NSException(name: NSInternalInconsistencyException,
                    reason:"Matchers must override match()",
                    userInfo: nil).raise()
    }
}