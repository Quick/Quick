//
//  QCKInvocationSpec.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import XCTest

class QCKInvocationSpec: QuickSpec {
    override class var isConcreteSpec: Bool { get { return true } }

    override class func exampleGroups() {
        describe("qck_className") {
            it("returns the name of the type of the object") {
                var string: NSString = "Hannah"
                let className = qck_className(string)
                XCTAssertEqualObjects(className, "__NSCFString", "expected class name")
            }
        }
    }
}
