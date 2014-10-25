//
//  FunctionalTests_SharedExamplesTests_SharedExamples.swift
//  Quick
//
//  Created by Brian Gesiak on 10/18/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Quick
import Nimble

class FunctionalTests_SharedExamplesTests_SharedExamples: QuickSharedExampleGroups {
    override class func sharedExampleGroups() {
        sharedExamples("a group of three shared examples") {
            it("passes once") { expect(true).to(beTruthy()) }
            it("passes twice") { expect(true).to(beTruthy()) }
            it("passes three times") { expect(true).to(beTruthy()) }
        }

        sharedExamples("shared examples that take a context") { (sharedExampleContext: SharedExampleContext) in
            it("is passed the correct parameters via the context") {
                let callsite = sharedExampleContext()["callsite"] as String
                expect(callsite).to(equal("SharedExamplesSpec"))
            }
        }
    }
}