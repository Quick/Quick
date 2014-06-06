//
//  QuickSpec.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import XCTest

var _calledCount = 0

class QuickSpec: XCTestCase {
    class var isConcreteSpec: Bool { get { return false } }

    override class func initialize() {
        currentExampleGroup = rootExampleGroupForSpecClass(self)
        exampleGroups()
    }
    class func exampleGroups() { }

    func runExampleAtIndex(index: Int) {
        rootExampleGroupForSpecClass(self.classForCoder).examples[index].run()
    }

    override class func testInvocations() -> AnyObject[]! {
        if !self.isConcreteSpec { return [] }

        var invocations: AnyObject[] = []
        for (index, _) in enumerate(rootExampleGroupForSpecClass(self).examples) {
            invocations.append(qck_invocationForExampleAtIndex(index))
        }
        return invocations
    }

    override var name: String! {
        get {
            let examples = rootExampleGroupForSpecClass(self.classForCoder).examples
            let name = NSStringFromClass(self.classForCoder) + examples[_calledCount/2].name

            if ++_calledCount/2 == examples.count {
                _calledCount = 0
            }

            return name
        }
    }
}
