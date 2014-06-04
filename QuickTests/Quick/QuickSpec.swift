//
//  QuickSpec.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import XCTest

class QuickSpec: XCTestCase {
    override var name: String! { get { return qck_className(self) } }

    override class func initialize() {
        exampleGroups()
    }

    class func exampleGroups() { }
    class var isConcreteSpec: Bool { get { return false } }

    func runExampleAtIndex(index: Int) {
        currentExampleGroup.examples[index].run()
    }

    override class func testInvocations() -> AnyObject[]! {
        if !self.isConcreteSpec {
            return []
        }

        var invocations: AnyObject[] = []
        for i in 0..currentExampleGroup.examples.count {
            invocations.append(qck_invocationForExampleAtIndex(i))
        }
        return invocations
    }
}
