//
//  RaiseSpec.swift
//  Nimble
//
//  Created by Brian Ivan Gesiak on 7/1/14.
//
//

import Quick
import Nimble

class RaiseSpec: QuickSpec {
    override func spec() {
        describe("Raise") {
            var matcher: Raise! = nil
            beforeEach { matcher = Raise() }

            describe("failureMessage") {
                it("says it expected the closure to raise") {
                    let message = matcher.failureMessage(nil)
                    expect(message).to.equal("expected subject to raise")
                }
            }

            describe("negativeFailureMessage") {
                it("says it expected the closure not to raise") {
                    let message = matcher.negativeFailureMessage(nil)
                    expect(message).to.equal("expected subject not to raise")
                }
            }
        }

        describe("raise()") {
            context("when the subject raises") {
                it("matches") {
                    expect{
                        NMBRaiseSpecHelper.raise()
                        return nil
                    }.to.raise()
                }
            }

            context("when the subject doesn't raise") {
                it("doesn't match") {
                    expect{nil}.notTo.raise()
                }
            }
        }
    }
}
