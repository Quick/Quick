#if canImport(Darwin)

@testable import Quick
import Nimble

private class A {}
private class B: A {}
private class C: B {}
private class D {}

final class SubclassDetectionSpec: QuickSpec {
    override func spec() {
        describe("detecting if a given class is a subclass of another") {
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

        describe("finding all subclasses of a given type") {
            it("finds only subclasses, but not the actual class, of the desired type") {
                let foundSubclasses: [A.Type] = allSubclasses(ofType: A.self)
                expect(foundSubclasses).to(haveCount(2))
                expect(foundSubclasses.first).to(be(B.self) || be(C.self))
                expect(foundSubclasses.last).to(be(B.self) || be(C.self))
            }
        }
    }
}

#endif
