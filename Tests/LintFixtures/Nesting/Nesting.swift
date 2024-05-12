import Quick

// This also checks nesting, and the directory structure is set up to make sure it also checks nested files as well.
final class Nesting: QuickSpec {
    override class func spec() {
        fdescribe("a focused example group") {
            fit("still identifies focused examples later on") {}
        }

        fcontext("with multiple focuses on the same line") { fit("still identifies the focusing!") {} } // swiftlint:disable:this line_length
    }
}
