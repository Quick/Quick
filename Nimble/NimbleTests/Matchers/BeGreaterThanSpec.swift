//
//  BeGreaterThanSpec.swift
//  Nimble
//
//  Created by Bryan Enders on 6/24/14.
//

import Quick
import Nimble

class BeGreaterThanSpec: QuickSpec {
    override func spec() {
        describe("BeGreaterThan") {
            var matcher: BeGreaterThan! = nil
            var subject: NSObject?
            beforeEach { matcher = BeGreaterThan(55) }
            
            describe("failureMessage") {
                context("when the subject is nil") {
                    beforeEach { subject = nil }
                    it("says it expected subject not to be nil") {
                        let message = matcher.failureMessage(subject)
                        expect(message).to.equal("expected subject not to be nil")
                    }
                }
                
                context("when the subject is an Int") {
                    beforeEach { subject = 1 }
                    it("says it expected the subject to be greater than expected") {
                        let message = matcher.failureMessage(subject)
                        expect(message).to.equal("expected subject to be > '55', got '1'")
                    }
                }
                
                context("when the subject is a Double") {
                    beforeEach { subject = 12.34 }
                    it("says it expected the subject to be greater than expected") {
                        let message = matcher.failureMessage(subject)
                        expect(message).to.equal("expected subject to be > '55', got '12.34'")
                    }
                }
                
                context("when the subject is a Number") {
                    beforeEach { subject = NSNumber(double: 55) }
                    it("says it expected the subject to be greater than expected") {
                        let message = matcher.failureMessage(subject)
                        expect(message).to.equal("expected subject to be > '55', got '55'")
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
                    beforeEach { subject = 100 }
                    it("says it expected the subject not to be greater than expected") {
                        let message = matcher.negativeFailureMessage(subject)
                        expect(message).to.equal("expected subject not to be > '55', got '100'")
                    }
                }
                
                context("when the subject is a Double") {
                    beforeEach { subject = 189 }
                    it("says it expected the subject not to be greater than expected") {
                        let message = matcher.negativeFailureMessage(subject)
                        expect(message).to.equal("expected subject not to be > '55', got '189'")
                    }
                }
                
                context("when the subject is a Number") {
                    beforeEach { subject = NSNumber(double: 55.5) }
                    it("says it expected the subject not to be greater than expected") {
                        let message = matcher.negativeFailureMessage(subject)
                        expect(message).to.equal("expected subject not to be > '55', got '55.5'")
                    }
                }
            }
        }
        
        describe("beGreaterThan()") {
            context("when the subject is an optional Int") {
                var subject: Int?
                
                context("and nil") {
                    it("does not match") {
                        expect(subject).notTo.beGreaterThan(5)
                        expect(subject).notTo.beGreaterThan(3.14159)
                        expect(subject).notTo.beGreaterThan(NSNumber(float: 2.5))
                        expect(subject).notTo.beGreaterThan(nil)
                    }
                }
                
                context("and non-nil") {
                    beforeEach { subject = 79 }
                    context("and it is greater than expected") {
                        it("matches") {
                            expect(subject).to.beGreaterThan(60)
                        }
                    }
                    
                    context("but it is less than expected") {
                        it("doesn't match") {
                            expect(subject).notTo.beGreaterThan(101)
                        }
                    }
                    
                    context("but it is equal to expected") {
                        it("doesn't match") {
                            expect(subject).notTo.beGreaterThan(79)
                        }
                    }
                }
            }
            
            context("when the subject is an Int") {
                var subject: Int = 1
                
                context("and it is greater than expected") {
                    it("matches") {
                        expect(subject).to.beGreaterThan(-5)
                    }
                }
                
                context("but it is less than expected") {
                    it("doesn't match") {
                        expect(subject).notTo.beGreaterThan(7)
                    }
                }
                
                context("but it is equal to expected") {
                    it("doesn't match") {
                        expect(subject).notTo.beGreaterThan(1)
                    }
                }
            }
            
            context("when the subject is an optional Double") {
                var subject: Double?
                
                context("and nil") {
                    it("does not match") {
                        expect(subject).notTo.beGreaterThan(5)
                        expect(subject).notTo.beGreaterThan(3.14159)
                        expect(subject).notTo.beGreaterThan(NSNumber(float: 2.5))
                        expect(subject).notTo.beGreaterThan(nil)
                    }
                }
                
                context("and non-nil") {
                    beforeEach { subject = 333.333 }
                    context("and it is greater than expected") {
                        it("matches") {
                            expect(subject).to.beGreaterThan(25.52)
                        }
                    }
                    
                    context("but it is less than expected") {
                        it("doesn't match") {
                            expect(subject).notTo.beGreaterThan(505.505)
                        }
                    }
                    
                    context("but it is equal to expected") {
                        it("doesn't match") {
                            expect(subject).notTo.beGreaterThan(333.333)
                        }
                    }
                }
            }
            
            context("when the subject is a Double") {
                var subject: Double = 90.09
                
                context("and it is greater than expected") {
                    it("matches") {
                        expect(subject).to.beGreaterThan(50.05)
                    }
                }
                
                context("but it is less than expected") {
                    it("doesn't match") {
                        expect(subject).notTo.beGreaterThan(100.001)
                    }
                }
                
                context("but it is equal to expected") {
                    it("doesn't match") {
                        expect(subject).notTo.beGreaterThan(90.09)
                    }
                }
            }
            
            context("when the subject is an optional Number") {
                var subject: NSNumber?
                
                context("and nil") {
                    it("does not match") {
                        expect(subject).notTo.beGreaterThan(5)
                        expect(subject).notTo.beGreaterThan(3.14159)
                        expect(subject).notTo.beGreaterThan(NSNumber(float: 2.5))
                        expect(subject).notTo.beGreaterThan(nil)
                    }
                }
                
                context("and non-nil") {
                    beforeEach { subject = NSNumber(double: 8.8) }
                    context("and it is greater than expected") {
                        it("matches") {
                            expect(subject).to.beGreaterThan(1.1)
                            expect(subject).to.beGreaterThan(NSNumber(int: 0))
                        }
                    }
                    
                    context("but it is less than expected") {
                        it("doesn't match") {
                            expect(subject).notTo.beGreaterThan(10.01)
                            expect(subject).notTo.beGreaterThan(NSNumber(double: 13.31))
                        }
                    }
                    
                    context("but it is equal to expected") {
                        it("doesn't match") {
                            expect(subject).notTo.beGreaterThan(8.8)
                            expect(subject).notTo.beGreaterThan(NSNumber(double: 8.8))
                        }
                    }
                }
            }
            
            context("when the subject is a Number") {
                var subject = NSNumber(double: 3.14159)
                
                context("and it is greater than expected") {
                    it("matches") {
                        expect(subject).to.beGreaterThan(2.2)
                        expect(subject).to.beGreaterThan(NSNumber(int: 3))
                    }
                }
                
                context("but it is less than expected") {
                    it("doesn't match") {
                        expect(subject).notTo.beGreaterThan(5)
                        expect(subject).notTo.beGreaterThan(NSNumber(double: 10))
                    }
                }
                
                context("but it is equal to expected") {
                    it("doesn't match") {
                        expect(subject).notTo.beGreaterThan(3.14159)
                        expect(subject).notTo.beGreaterThan(NSNumber(double: 3.14159))
                    }
                }
            }
        }
    }
}
