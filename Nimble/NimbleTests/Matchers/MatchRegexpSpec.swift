//
//  MatchRegexpSpec.swift
//  Nimble
//
//  Created by Dzianis Lebedzeu on 6/25/14.
//
//

import Quick
import Nimble


class MatchRegexpSpec: QuickSpec {
    override func spec() {
        describe("MatchRegexp") {
            var matcher: MatchRegexp! = nil
            beforeEach { matcher = MatchRegexp("Jof+rey") }
            
            describe("failureMessage") {
                it("says it doesn't match regexp") {
                    let message = matcher.failureMessage("Joffrey")
                    expect(message).to.equal("expected 'Jof+rey' to match 'Joffrey'")
                }
            }
            
            describe("negativeFailureMessage") {
                it("says it expected actual to not be equal to expected") {
                    let message = matcher.negativeFailureMessage("Jofrey")
                    expect(message).to.equal("expected 'Jofrey' not to match 'Jof+rey'")
                }
            }
        }
        
        describe("match()") {
            let expected = "Jo$$rey"
            
            context("matching regexp") {
                it("matches") {
                    expect("Joffrey").to.match("Jof+rey")
                }
            }
            
            context("not-matching regexp") {
                it("does not match") {
                    expect("Joffrey").toNot.match("Jo$$rey")
                }
            }
        }
    }
}