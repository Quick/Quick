//
//  PendingSpec.swift
//  Quick
//
//  Created by Tiago Bastos on 6/13/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Quick

class PendingSpec: QuickSpec {
    override func exampleGroups() {
        describe("Pending tests") {
            var specUsed = false

            pending("Pending Spec") {
                it ("changes the specUsed") {
                    specUsed = true
                }
            }

            it ("doesn't change specUsed") {
                expect(!specUsed).to.beTrue()
            }
        }
    }
}
