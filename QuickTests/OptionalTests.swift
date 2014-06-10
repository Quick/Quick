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

        it("is not set") {

            expect(person).toNot.beTrue()
            
        }
        

    }
}
