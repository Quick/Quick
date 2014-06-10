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

//            expect(person).to.beTrue()

        }
        

        





    }
}
