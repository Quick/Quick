//
//  ExampleTests.swift
//  ExampleTests
//
//  Created by Brian Ivan Gesiak on 6/8/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Quick
import Example

class ExampleTests: QuickSpec {
    override class func isConcreteSpec() -> Bool { return true }
    override class func exampleGroups() {
        describe("ViewController") {
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            var viewController: ViewController?
            beforeEach {
                viewController = storyboard.instantiateControllerWithIdentifier("ViewController") as? ViewController
                let view = viewController!.view // trigger viewDidLoad
            }

            it("thanks the user") {
                expect(viewController!.thankYouField.stringValue).to.equal("Thanks for using Quick!")
            }
        }
    }
}
