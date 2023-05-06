import Foundation
import Quick
import Nimble

class FunctionalTests_AsyncBehaviorTests_AsyncBehavior: AsyncBehavior<String> {
    override static func spec(_ aContext: @escaping () -> String) {
        it("passed the correct parameters via the context") {
            let callsite = aContext()
            expect(callsite).to(equal("BehaviorSpec"))
        }
    }
}

class FunctionalTests_AsyncBehaviorTests_AsyncBehavior2: AsyncBehavior<Void> {
    override static func spec(_ aContext: @escaping () -> Void) {
        it("passes once") { expect(true).to(beTruthy()) }
        it("passes twice") { expect(true).to(beTruthy()) }
        it("passes three times") { expect(true).to(beTruthy()) }
    }
}
