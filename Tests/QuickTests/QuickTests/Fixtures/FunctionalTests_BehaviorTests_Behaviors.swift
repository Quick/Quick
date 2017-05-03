//
//  FunctionalTests_BehaviorTests_Behaviors.swift
//  Quick
//
//  Created by Mostafa Amer on 19.04.17.
//  Copyright © 2017 Brian Ivan Gesiak. All rights reserved.
//

import Foundation
import Quick
import Nimble

class FunctionalTests_BehaviorTests_Behavior: Behavior<String> {
    override static func spec(_ aContext: @escaping () -> String) {
        it("passed the correct parameters via the context") {
            let callsite = aContext()
            expect(callsite).to(equal("BehaviorSpec"))
        }
    }
}

class FunctionalTests_BehaviorTests_Behavior2: Behavior<Void> {
    override static func spec(_ aContext: @escaping () -> Void) {
        it("passes once") { expect(true).to(beTruthy()) }
        it("passes twice") { expect(true).to(beTruthy()) }
        it("passes three times") { expect(true).to(beTruthy()) }
    }
}
