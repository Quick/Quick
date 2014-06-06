//
//  True.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation
import XCTest

extension Target {
    func beTrue() {
        XCTAssert(actual == true, "expected \(actual) to be true")
    }
}
