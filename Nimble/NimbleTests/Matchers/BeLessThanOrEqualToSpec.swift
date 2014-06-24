//
//  BeLessThanOrEqualToSpec.swift
//  Nimble
//
//  Created by Bryan Enders on 6/24/14.
//

import Quick
import Nimble

class BeLessThanOrEqualToSpec: QuickSpec {
    override func spec() {
        describe("BeLessThanOrEqualTo") {
            var matcher: BeLessThanOrEqualTo! = nil
            var subject: NSObject?
            beforeEach { matcher = BeLessThanOrEqualTo(42) }
            
            describe("failureMessage") {
                context("when the subject is nil") {
                    beforeEach { subject = nil }
                    it("says it expected subject to not be nil") {
                        let message = matcher.failureMessage(subject)
                        expect(message).to.equal("expected subject to not be nil")
                    }
                }
                
                context("when the subject is an Int") {
                    beforeEach { subject = 55 }
                    it("says it expected the subject to be less than or equal to expected") {
                        let message = matcher.failureMessage(subject)
                        expect(message).to.equal("expected subject to be <= '42', got '55'")
                    }
                }
                
                context("when the subject is a Double") {
                    beforeEach { subject = 42.1 }
                    it("says it expected the subject to be less than or equal to expected") {
                        let message = matcher.failureMessage(subject)
                        expect(message).to.equal("expected subject to be <= '42', got '42.1'")
                    }
                }
                
                context("when the subject is a Number") {
                    beforeEach { subject = NSNumber(int: 1_000) }
                    it("says it expected the subject to be less than or equal to expected") {
                        let message = matcher.failureMessage(subject)
                        expect(message).to.equal("expected subject to be <= '42', got '1000'")
                    }
                }
            }
            
            describe("negativeFailureMessage") {
                context("when the subject is nil") {
                    beforeEach { subject = nil }
                    it("says it expected subject to not be nil") {
                        let message = matcher.negativeFailureMessage(subject)
                        expect(message).to.equal("expected subject to not be nil")
                    }
                }
                
                context("when the subject is an Int") {
                    beforeEach { subject = 42 }
                    it("says it expected the subject to not be less than or equal to expected") {
                        let message = matcher.negativeFailureMessage(subject)
                        expect(message).to.equal("expected subject to not be <= '42', got '42'")
                    }
                }
                
                context("when the subject is a Double") {
                    beforeEach { subject = 6.66 }
                    it("says it expected the subject to not be less than or equal to expected") {
                        let message = matcher.negativeFailureMessage(subject)
                        expect(message).to.equal("expected subject to not be <= '42', got '6.66'")
                    }
                }
                
                context("when the subject is a Number") {
                    beforeEach { subject = NSNumber(int: 0) }
                    it("says it expected the subject to not be less than or equal to expected") {
                        let message = matcher.negativeFailureMessage(subject)
                        expect(message).to.equal("expected subject to not be <= '42', got '0'")
                    }
                }
            }
        }
        
        describe("beLessThanOrEqualTo()") {
            context("when the subject is an optional Int") {
                var subject: Int?
                
                context("and nil") {
                    it("does not match") {
                        expect(subject).toNot.beLessThanOrEqualTo(5)
                        expect(subject).toNot.beLessThanOrEqualTo(3.14159)
                        expect(subject).toNot.beLessThanOrEqualTo(NSNumber(float: 2.5))
                        expect(subject).toNot.beLessThanOrEqualTo(nil)
                    }
                }
                
                context("and non-nil") {
                    beforeEach { subject = 976 }
                    context("and it is less than expected") {
                        it("matches") {
                            expect(subject).to.beLessThanOrEqualTo(1_000)
                        }
                    }
                    
                    context("and it is equal to expected") {
                        it("matches") {
                            expect(subject).to.beLessThanOrEqualTo(976)
                        }
                    }
                    
                    context("but it is greater than expected") {
                        it("doesn't match") {
                            expect(subject).toNot.beLessThanOrEqualTo(9)
                        }
                    }
                }
            }
            
            context("when the subject is an Int") {
                var subject: Int = 1_234
                
                context("and it is less than expected") {
                    it("matches") {
                        expect(subject).to.beLessThanOrEqualTo(2_000)
                    }
                }
                
                context("and it is equal to expected") {
                    it("matches") {
                        expect(subject).to.beLessThanOrEqualTo(1_234)
                    }
                }
                
                context("but it is greater than expected") {
                    it("doesn't match") {
                        expect(subject).toNot.beLessThanOrEqualTo(13)
                    }
                }
            }
            
            context("when the subject is an optional Double") {
                var subject: Double?
                
                context("and nil") {
                    it("does not match") {
                        expect(subject).toNot.beLessThanOrEqualTo(5)
                        expect(subject).toNot.beLessThanOrEqualTo(3.14159)
                        expect(subject).toNot.beLessThanOrEqualTo(NSNumber(float: 2.5))
                        expect(subject).toNot.beLessThanOrEqualTo(nil)
                    }
                }
                
                context("and non-nil") {
                    beforeEach { subject = 9.98 }
                    context("and it is less than expected") {
                        it("matches") {
                            expect(subject).to.beLessThanOrEqualTo(9.99)
                        }
                    }
                    
                    context("and it is equal to expected") {
                        it("matches") {
                            expect(subject).to.beLessThanOrEqualTo(9.98)
                        }
                    }
                    
                    context("but it is greater than expected") {
                        it("doesn't match") {
                            expect(subject).toNot.beLessThanOrEqualTo(5.55)
                        }
                    }
                }
            }
            
            context("when the subject is a Double") {
                var subject: Double = 2.22
                
                context("and it is less than expected") {
                    it("matches") {
                        expect(subject).to.beLessThanOrEqualTo(3.22)
                    }
                }
                
                context("and it is equal to expected") {
                    it("matches") {
                        expect(subject).to.beLessThanOrEqualTo(2.22)
                    }
                }
                
                context("but it is greater than expected") {
                    it("doesn't match") {
                        expect(subject).toNot.beLessThanOrEqualTo(-1.11)
                    }
                }
            }
            
            context("when the subject is an optional Number") {
                var subject: NSNumber?
                
                context("and nil") {
                    it("does not match") {
                        expect(subject).toNot.beLessThanOrEqualTo(5)
                        expect(subject).toNot.beLessThanOrEqualTo(3.14159)
                        expect(subject).toNot.beLessThanOrEqualTo(NSNumber(float: 2.5))
                        expect(subject).toNot.beLessThanOrEqualTo(nil)
                    }
                }
                
                context("and non-nil") {
                    beforeEach { subject = NSNumber(double: -100.001) }
                    context("and it is less than expected") {
                        it("matches") {
                            expect(subject).to.beLessThanOrEqualTo(5)
                            expect(subject).to.beLessThanOrEqualTo(NSNumber(float: 0))
                        }
                    }
                    
                    context("and it is equal to expected") {
                        it("matches") {
                            expect(subject).to.beLessThanOrEqualTo(-100.001)
                            expect(subject).to.beLessThanOrEqualTo(NSNumber(double: -100.001))
                        }
                    }
                    
                    context("but it is greater than expected") {
                        it("doesn't match") {
                            expect(subject).toNot.beLessThanOrEqualTo(-200.1)
                            expect(subject).toNot.beLessThanOrEqualTo(NSNumber(int: -101))
                        }
                    }
                }
            }
            
            context("when the subject is a Number") {
                var subject = NSNumber(int: 7)
                
                context("and it is less than expected") {
                    it("matches") {
                        expect(subject).to.beLessThanOrEqualTo(10)
                        expect(subject).to.beLessThanOrEqualTo(NSNumber(double: 200.5))
                    }
                }
                
                context("and it is equal to expected") {
                    it("matches") {
                        expect(subject).to.beLessThanOrEqualTo(7.0)
                        expect(subject).to.beLessThanOrEqualTo(NSNumber(double: 7))
                    }
                }
                
                context("but it is greater than expected") {
                    it("doesn't match") {
                        expect(subject).toNot.beLessThanOrEqualTo(1.1)
                        expect(subject).toNot.beLessThanOrEqualTo(NSNumber(int: 6))
                    }
                }
            }
        }
    }
}
