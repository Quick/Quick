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
    class var isConcreteSpec: Bool { get { return false } }

    override class func initialize() {
        currentSpec = specName
        currentExampleGroup = rootExampleGroupForSpec(specName)
        exampleGroups()
    }
    class var specName: String { get { return NSStringFromClass(self) } }
    class func exampleGroups() { }

    func runExampleAtIndex(index: Int) {
        rootExampleGroupForSpec(qck_className(self)).examples[index].run()
    }

    override class func testInvocations() -> AnyObject[]! {
        if !self.isConcreteSpec {
            return []
        }

        var invocations: AnyObject[] = []
        for i in 0..rootExampleGroupForSpec(specName).examples.count {
            invocations.append(qck_invocationForExampleAtIndex(i))
        }
        return invocations
    }
}
