//
//  RecieveNotificationSpec.swift
//  Nimble
//
//  Created by Dzianis Lebedzeu on 6/19/14.
//
//

import Quick
import Nimble

class RecieveNotificationSpec: QuickSpec {
    override func spec() {
        describe("RecieveNotification") {
            var matcher: ReceiveNotification! = nil
            beforeEach { matcher = ReceiveNotification("Winter is coming") }
            
            describe("failureMessage") {
                it("says it expected one value, but got another") {
                    let message = matcher.failureMessage("")
                    expect(message).to.equal("expected subject to receive 'Winter is coming'")
                }
            }
            
            describe("negativeFailureMessage") {
                it("says it expected actual to not be equal to expected") {
                    let message = matcher.negativeFailureMessage("Kingsguard")
                    expect(message).to.equal("expected subject not to receive 'Winter is coming'")
                }
            }
        }
        
        describe("receive()") {
            let expected = "Winter is coming"
            
//            context("notification is sent") {
//                it("matches") {
//                    expect({
//                        NSNotificationCenter.defaultCenter().postNotificationName("Winter is coming", object: nil)
//                    }).will.receive(expected)
//                }
//            }
//
//            context("notification is not sent") {
//                it("does not match") {
//                    expect({
//                        NSNotificationCenter.defaultCenter().postNotificationName("", object: nil)
//                    }).willNot.receive(expected)
//                }
//            }
        }
    }
}