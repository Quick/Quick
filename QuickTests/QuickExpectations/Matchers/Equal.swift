//
//  Equal.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation
import XCTest

extension Target {
    func equal(expected: NSObject) {
        XCTAssertEqualObjects(actual, expected, "expected \(actual) to equal \(expected)")
    }
}
