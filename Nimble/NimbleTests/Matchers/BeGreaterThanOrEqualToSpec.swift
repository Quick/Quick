//
//  BeGreaterThanOrEqualToSpec.swift
//  Nimble
//
//  Created by Bryan Enders on 6/24/14.
//

import Quick
import Nimble

class BeGreaterThanOrEqualToSpec: QuickSpec {
    override func spec() {
        describe("BeGreaterThanOrEqualTo") {
            var matcher: BeGreaterThanOrEqualTo! = nil
            var subject: NSObject?
            beforeEach { matcher = BeGreaterThanOrEqualTo(97.78) }
            
            describe("failureMessage") {
                context("when the subject is nil") {
                    beforeEach { subject = nil }
                    it("says it expected subject not to be nil") {
                        let message = matcher.failureMessage(subject)
                        expect(message).to.equal("expected subject not to be nil")
                    }
                }
                
                context("when the subject is an Int") {
                    beforeEach { subject = 33 }
                    it("says it expected the subject to be greater than or equal to expected") {
                        let message = matcher.failureMessage(subject)
                        expect(message).to.equal("expected subject to be >= '97.78', got '33'")
                    }
                }
                
                context("when the subject is a Double") {
                    beforeEach { subject = 12.21 }
                    it("says it expected the subject to be greater than or equal to expected") {
                        let message = matcher.failureMessage(subject)
                        expect(message).to.equal("expected subject to be >= '97.78', got '12.21'")
                    }
                }
                
                context("when the subject is a Number") {
                    beforeEach { subject = NSNumber(int: 4) }
                    it("says it expected the subject to be greater than or equal to expected") {
                        let message = matcher.failureMessage(subject)
                        expect(message).to.equal("expected subject to be >= '97.78', got '4'")
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
                    it("says it expected the subject not to be greater than or equal to expected") {
                        let message = matcher.negativeFailureMessage(subject)
                        expect(message).to.equal("expected subject not to be >= '97.78', got '100'")
                    }
                }
                
                context("when the subject is a Double") {
                    beforeEach { subject = 666.6 }
                    it("says it expected the subject not to be greater than or equal to expected") {
                        let message = matcher.negativeFailureMessage(subject)
                        expect(message).to.equal("expected subject not to be >= '97.78', got '666.6'")
                    }
                }
                
                context("when the subject is a Number") {
                    beforeEach { subject = NSNumber(int: 1_000) }
                    it("says it expected the subject not to be greater than or equal to expected") {
                        let message = matcher.negativeFailureMessage(subject)
                        expect(message).to.equal("expected subject not to be >= '97.78', got '1000'")
                    }
                }
            }
        }
        
        describe("beGreaterThanOrEqualTo()") {
            context("when the subject is an optional Int") {
                var subject: Int?
                
                context("and nil") {
                    it("does not match") {
                        expect(subject).notTo.beGreaterThanOrEqualTo(5)
                        expect(subject).toNot.beGreaterThanOrEqualTo(3.14159)
                        expect(subject).notTo.beGreaterThanOrEqualTo(NSNumber(float: 2.5))
                        expect(subject).toNot.beGreaterThanOrEqualTo(nil)
                    }
                }
                
                context("and non-nil") {
                    beforeEach { subject = 25 }
                    context("and it is greater than expected") {
                        it("matches") {
                            expect(subject).to.beGreaterThanOrEqualTo(7)
                        }
                    }
                    
                    context("and it is equal to expected") {
                        it("matches") {
                            expect(subject).to.beGreaterThanOrEqualTo(25)
                        }
                    }
                    
                    context("but it is less than expected") {
                        it("doesn't match") {
                            expect(subject).notTo.beGreaterThanOrEqualTo(100)
                        }
                    }
                }
            }
            
            context("when the subject is an Int") {
                var subject: Int = 424
                
                context("and it is greater than expected") {
                    it("matches") {
                        expect(subject).to.beGreaterThanOrEqualTo(22)
                    }
                }
                
                context("and it is equal to expected") {
                    it("matches") {
                        expect(subject).to.beGreaterThanOrEqualTo(424)
                    }
                }
                
                context("but it is less than expected") {
                    it("doesn't match") {
                        expect(subject).toNot.beGreaterThanOrEqualTo(1_111)
                    }
                }
            }
            
            context("when the subject is an optional Double") {
                var subject: Double?
                
                context("and nil") {
                    it("does not match") {
                        expect(subject).notTo.beGreaterThanOrEqualTo(5)
                        expect(subject).toNot.beGreaterThanOrEqualTo(3.14159)
                        expect(subject).notTo.beGreaterThanOrEqualTo(NSNumber(float: 2.5))
                        expect(subject).toNot.beGreaterThanOrEqualTo(nil)
                    }
                }
                
                context("and non-nil") {
                    beforeEach { subject = 18.81 }
                    context("and it is greater than expected") {
                        it("matches") {
                            expect(subject).to.beGreaterThanOrEqualTo(10.01)
                        }
                    }
                    
                    context("and it is equal to expected") {
                        it("matches") {
                            expect(subject).to.beGreaterThanOrEqualTo(18.81)
                        }
                    }
                    
                    context("but it is less than expected") {
                        it("doesn't match") {
                            expect(subject).notTo.beGreaterThanOrEqualTo(88.88)
                        }
                    }
                }
            }
            
            context("when the subject is a Double") {
                var subject: Double = 7.5
                
                context("and it is greater than expected") {
                    it("matches") {
                        expect(subject).to.beGreaterThanOrEqualTo(1.1)
                    }
                }
                
                context("and it is equal to expected") {
                    it("matches") {
                        expect(subject).to.beGreaterThanOrEqualTo(7.5)
                    }
                }
                
                context("but it is less than expected") {
                    it("doesn't match") {
                        expect(subject).toNot.beGreaterThanOrEqualTo(838.5)
                    }
                }
            }
            
            context("when the subject is an optional Number") {
                var subject: NSNumber?
                
                context("and nil") {
                    it("does not match") {
                        expect(subject).notTo.beGreaterThanOrEqualTo(5)
                        expect(subject).toNot.beGreaterThanOrEqualTo(3.14159)
                        expect(subject).notTo.beGreaterThanOrEqualTo(NSNumber(float: 2.5))
                        expect(subject).toNot.beGreaterThanOrEqualTo(nil)
                    }
                }
                
                context("and non-nil") {
                    beforeEach { subject = NSNumber(int: 40) }
                    context("and it is greater than expected") {
                        it("matches") {
                            expect(subject).to.beGreaterThanOrEqualTo(12)
                            expect(subject).to.beGreaterThanOrEqualTo(NSNumber(float: 32.4))
                        }
                    }
                    
                    context("and it is equal to expected") {
                        it("matches") {
                            expect(subject).to.beGreaterThanOrEqualTo(40)
                            expect(subject).to.beGreaterThanOrEqualTo(NSNumber(double: 40.0))
                        }
                    }
                    
                    context("but it is less than expected") {
                        it("doesn't match") {
                            expect(subject).notTo.beGreaterThanOrEqualTo(50)
                            expect(subject).toNot.beGreaterThanOrEqualTo(NSNumber(double: 77.77))
                        }
                    }
                }
            }
            
            context("when the subject is a Number") {
                var subject = NSNumber(double: 13.3)
                
                context("and it is greater than expected") {
                    it("matches") {
                        expect(subject).to.beGreaterThanOrEqualTo(9)
                        expect(subject).to.beGreaterThanOrEqualTo(NSNumber(double: 1.5))
                    }
                }
                
                context("and it is equal to expected") {
                    it("matches") {
                        expect(subject).to.beGreaterThanOrEqualTo(13.3)
                        expect(subject).to.beGreaterThanOrEqualTo(NSNumber(double: 13.3))
                    }
                }
                
                context("but it is less than expected") {
                    it("doesn't match") {
                        expect(subject).notTo.beGreaterThanOrEqualTo(1_000)
                        expect(subject).toNot.beGreaterThanOrEqualTo(NSNumber(int: 14))
                    }
                }
            }
        }
    }
}
