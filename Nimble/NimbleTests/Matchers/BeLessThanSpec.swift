//
//  BeLessThanSpec.swift
//  Nimble
//
//  Created by Bryan Enders on 6/24/14.
//

import Quick
import Nimble

class BeLessThanSpec: QuickSpec {
    override func spec() {
        describe("BeLessThan") {
            var matcher: BeLessThan! = nil
            var subject: NSObject?
            beforeEach { matcher = BeLessThan(10) }
            
            describe("failureMessage") {
                context("when the subject is nil") {
                    beforeEach { subject = nil }
                    it("says it expected subject not to be nil") {
                        let message = matcher.failureMessage(subject)
                        expect(message).to.equal("expected subject not to be nil")
                    }
                }
                
                context("when the subject is an Int") {
                    beforeEach { subject = 13_000 }
                    it("says it expected the subject to be less than expected") {
                        let message = matcher.failureMessage(subject)
                        expect(message).to.equal("expected subject to be < '10', got '13000'")
                    }
                }
                
                context("when the subject is a Double") {
                    beforeEach { subject = 48.15162342 }
                    it("says it expected the subject to be less than expected") {
                        let message = matcher.failureMessage(subject)
                        expect(message).to.equal("expected subject to be < '10', got '48.15162342'")
                    }
                }
                
                context("when the subject is a Number") {
                    beforeEach { subject = NSNumber(int: 19) }
                    it("says it expected the subject to be less than expected") {
                        let message = matcher.failureMessage(subject)
                        expect(message).to.equal("expected subject to be < '10', got '19'")
                    }
                }
            }
            
            describe("negativeFailureMessage") {
                context("when the subject is nil") {
                    beforeEach { subject = nil }
                    it("says it expected subject not to be nil") {
                        let message = matcher.negativeFailureMessage(subject)
                        expect(message).to.equal("expected subject not to be nil")
                    }
                }
                
                context("when the subject is an Int") {
                    beforeEach { subject = 1 }
                    it("says it expected the subject not to be less than expected") {
                        let message = matcher.negativeFailureMessage(subject)
                        expect(message).to.equal("expected subject not to be < '10', got '1'")
                    }
                }
                
                context("when the subject is a Double") {
                    beforeEach { subject = 7.91000 }
                    it("says it expected the subject not to be less than expected") {
                        let message = matcher.negativeFailureMessage(subject)
                        expect(message).to.equal("expected subject not to be < '10', got '7.91'")
                    }
                }
                
                context("when the subject is a Number") {
                    beforeEach { subject = NSNumber(double: 1.23) }
                    it("says it expected the subject not to be less than expected") {
                        let message = matcher.negativeFailureMessage(subject)
                        expect(message).to.equal("expected subject not to be < '10', got '1.23'")
                    }
                }
            }
        }
        
        describe("beLessThan()") {
            context("when the subject is an optional Int") {
                var subject: Int?
                
                context("and nil") {
                    it("does not match") {
                        expect(subject).notTo.beLessThan(5)
                        expect(subject).toNot.beLessThan(3.14159)
                        expect(subject).notTo.beLessThan(NSNumber(float: 2.5))
                        expect(subject).toNot.beLessThan(nil)
                    }
                }
                
                context("and non-nil") {
                    beforeEach { subject = 42 }
                    context("and it is less than expected") {
                        it("matches") {
                            expect(subject).to.beLessThan(50)
                        }
                    }
                    
                    context("but it is greater than expected") {
                        it("doesn't match") {
                            expect(subject).notTo.beLessThan(10)
                        }
                    }
                    
                    context("but it is equal to expected") {
                        it("doesn't match") {
                            expect(subject).toNot.beLessThan(42)
                        }
                    }
                }
            }
            
            context("when the subject is an Int") {
                var subject: Int = 7
                
                context("and it is less than expected") {
                    it("matches") {
                        expect(subject).to.beLessThan(10)
                    }
                }
                
                context("but it is greater than expected") {
                    it("doesn't match") {
                        expect(subject).notTo.beLessThan(5)
                    }
                }
                
                context("but it is equal to expected") {
                    it("doesn't match") {
                        expect(subject).toNot.beLessThan(7)
                    }
                }
            }
            
            context("when the subject is an optional Double") {
                var subject: Double?
                
                context("and nil") {
                    it("does not match") {
                        expect(subject).notTo.beLessThan(5)
                        expect(subject).toNot.beLessThan(3.14159)
                        expect(subject).notTo.beLessThan(NSNumber(float: 2.5))
                        expect(subject).toNot.beLessThan(nil)
                    }
                }
                
                context("and non-nil") {
                    beforeEach { subject = 2.5 }
                    context("and it is less than expected") {
                        it("matches") {
                            expect(subject).to.beLessThan(7.25)
                        }
                    }
                    
                    context("but it is greater than expected") {
                        it("doesn't match") {
                            expect(subject).notTo.beLessThan(-1.0)
                        }
                    }
                    
                    context("but it is equal to expected") {
                        it("doesn't match") {
                            expect(subject).toNot.beLessThan(2.5)
                        }
                    }
                }
            }
            
            context("when the subject is a Double") {
                var subject: Double = -6.66
                
                context("and it is less than expected") {
                    it("matches") {
                        expect(subject).to.beLessThan(0.5)
                    }
                }
                
                context("but it is greater than expected") {
                    it("doesn't match") {
                        expect(subject).notTo.beLessThan(-10.1)
                    }
                }
                
                context("but it is equal to expected") {
                    it("doesn't match") {
                        expect(subject).toNot.beLessThan(-6.66)
                    }
                }
            }
            
            context("when the subject is an optional Number") {
                var subject: NSNumber?
                
                context("and nil") {
                    it("does not match") {
                        expect(subject).notTo.beLessThan(5)
                        expect(subject).toNot.beLessThan(3.14159)
                        expect(subject).notTo.beLessThan(NSNumber(float: 2.5))
                        expect(subject).toNot.beLessThan(nil)
                    }
                }
                
                context("and non-nil") {
                    beforeEach { subject = NSNumber(int: 13) }
                    context("and it is less than expected") {
                        it("matches") {
                            expect(subject).to.beLessThan(20)
                            expect(subject).to.beLessThan(NSNumber(float: 50.5))
                        }
                    }
                    
                    context("but it is greater than expected") {
                        it("doesn't match") {
                            expect(subject).notTo.beLessThan(4.5)
                            expect(subject).toNot.beLessThan(NSNumber(int: 1))
                        }
                    }
                    
                    context("but it is equal to expected") {
                        it("doesn't match") {
                            expect(subject).notTo.beLessThan(13)
                            expect(subject).toNot.beLessThan(13.0)
                            expect(subject).notTo.beLessThan(NSNumber(int: 13))
                        }
                    }
                }
            }
            
            context("when the subject is a Number") {
                var subject = NSNumber(double: 3.14159)
                
                context("and it is less than expected") {
                    it("matches") {
                        expect(subject).to.beLessThan(5.0)
                        expect(subject).to.beLessThan(NSNumber(int: 28))
                    }
                }
                
                context("but it is greater than expected") {
                    it("doesn't match") {
                        expect(subject).toNot.beLessThan(0)
                        expect(subject).notTo.beLessThan(NSNumber(double: 2.3))
                    }
                }
                
                context("but it is equal to expected") {
                    it("doesn't match") {
                        expect(subject).toNot.beLessThan(3.14159)
                        expect(subject).notTo.beLessThan(NSNumber(double: 3.14159))
                    }
                }
            }
        }
    }
}
