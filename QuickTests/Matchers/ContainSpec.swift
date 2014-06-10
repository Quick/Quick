//
//  ContainsSpec.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Quick

class ContainSpec: QuickSpec {
    override class func exampleGroups() {
        describe("Contain") {
            var matcher: Contain?
            var subject: String[]?
            beforeEach {
                matcher = Contain("Jon Snow")
                subject = [ "Robb Stark", "Sansa Stark" ]
            }

            describe("failureMessage") {
                it("says it expected subject to contain expected") {
                    let message = matcher!.failureMessage(subject)
                    expect(message).to.equal("expected '[ Robb Stark, Sansa Stark ]' to contain 'Jon Snow'")
                }
            }

            describe("negativeFailureMessage") {
                it("says it expected subject to not contain expected") {
                    let message = matcher!.negativeFailureMessage(subject)
                    expect(message).to.equal("expected '[ Robb Stark, Sansa Stark ]' to not contain 'Jon Snow'")
                }
            }
        }

        describe("contain()") {
            context("when the subject is an array") {
                var subject: AnyObject[] = []
                beforeEach { subject = [3, 1, 10, 2] }

                context("and it contains the element") {
                    it("matches") { expect(subject).to.contain(10) }
                }

                context("but it doesn't contain the element") {
                    it("doesn't match") { expect(subject).notTo.contain(20) }
                }
            }

            context("when the subject is a set") {
                var subject: NSSet = NSSet()
                beforeEach { subject = NSSet(objects: 1, 3, 9) }

                context("and it contains the element") {
                    it("matches") { expect(subject).to.contain(3) }
                }

                context("but it doesn't contain the element") {
                    it("doesn't match") { expect(subject).notTo.contain(11) }
                }
            }

            context("when the subject is neither an array nor a set") {
                it("doesn't match") {
                    expect(10).notTo.contain(1)
                }
            }
        }
    }
}
