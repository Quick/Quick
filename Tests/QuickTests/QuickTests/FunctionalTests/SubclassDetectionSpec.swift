@testable import Quick
import Nimble

private class A {}
private class B: A {}
private class C: B {}
private class D {}

final class SubclassDetectionSpec: QuickSpec {
    override func spec() {
        it("detects when a class is an immediate subclass of another") {
            expect(isClass(B.self, aSubclassOf: A.self)).to(beTrue())
        }

        it("detects when a class is an indirect subclass of another") {
            expect(isClass(C.self, aSubclassOf: A.self)).to(beTrue())
        }

        it("returns false when a class is not at all related to the superclass") {
            expect(isClass(D.self, aSubclassOf: A.self)).to(beFalse())
            expect(isClass(D.self, aSubclassOf: B.self)).to(beFalse())
            expect(isClass(D.self, aSubclassOf: C.self)).to(beFalse())
        }
    }
}
