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

        var person: Person?

        context("nil subject") {

            beforeEach { person = nil }

            it("to be nil") {

                expect(person).to.beNil()
                
            }

        }

        context("non-nil subject") {

            beforeEach { person = Person() }

            afterEach { person = nil }

            it("to not be nil") {

                expect(person).toNot.beNil()
                
            }
            
            it("not to be nil") {

                expect(person).notTo.beNil()
                
            }

        }

        context("non-optional") {

            var person = Person()

            it("to not be nil") {

                expect(person).toNot.beNil()

            }

        }

        context("true") {

            context("nil bool") {

                var optBool : Bool?
                
                it("should be false") {

                    expect(optBool).toNot.beTrue()

                }

            }

            context("true bool") {

                var optBool : Bool? = true

                it("should be true") {

                    expect(optBool).to.beTrue()

                }
                
            }
            
            context("false bool") {

                var optBool : Bool? = false

                it("should be true") {

                    expect(optBool).toNot.beTrue()

                }
                
            }

        }

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
