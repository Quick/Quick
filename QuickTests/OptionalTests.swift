//
//  OptionalTests.swift
//  Quick
//
//  Created by Dave Meehan on 10/06/2014.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Quick

class OptionalSpec : QuickSpec {

    override class func exampleGroups() {

        context("contains") {

            context("nil array") {

                var optArray: Int[]?

                it("does not contain") {

                    expect(optArray).toNot.contain(123)

                }

            }

            context("assigned array") {

                var optArray: Int[]? = [ 1, 2, 3 ]

                it("contains 2") {

                    expect(optArray).to.contain(2)

                }

                it("does not contains 4") {

                    expect(optArray).toNot.contain(4)

                }

            }

        }
    }
}
