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

        context("equal") {

            context("nil value") {

                var optVal : String?

                it("does not equal empty string") {

                    expect(optVal).toNot.equal("")
                    
                }

            }

            context("empty string") {

                var optVal : String? = ""

                it("does equal an empty string") {

                    expect(optVal).to.equal("")

                }
                
            }

            context("non-empty string") {

                var optVal : String? = "Hello World"

                it("equals Hello Word") {

                    expect(optVal).to.equal("Hello World")

                }

            }

        }

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
