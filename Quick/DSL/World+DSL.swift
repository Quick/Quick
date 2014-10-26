/**
    Adds methods to World to support top-level DSL functions (Swift) and
    macros (Objective-C). These functions map directly to the DSL test
    writers use in their specs.
*/
extension World {
    public func beforeSuite(closure: () -> ()) {
        appendBeforeSuite(closure)
    }

    public func afterSuite(closure: () -> ()) {
        appendAfterSuite(closure)
    }

    public func sharedExamples(name: String, closure: SharedExampleClosure) {
        registerSharedExample(name, closure: closure)
    }

    public func describe(description: String, closure: () -> ()) {
        var group = ExampleGroup(description: description)
        currentExampleGroup!.appendExampleGroup(group)
        currentExampleGroup = group
        closure()
        currentExampleGroup = group.parent
    }

    public func context(description: String, closure: () -> ()) {
        describe(description, closure: closure)
    }

    public func beforeEach(closure: () -> ()) {
        currentExampleGroup!.appendBefore { (exampleMetadata: ExampleMetadata) in
            closure()
        }
    }

    public func beforeEach(#closure: (exampleMetadata: ExampleMetadata) -> ()) {
        currentExampleGroup!.appendBefore(closure)
    }

    public func afterEach(closure: () -> ()) {
        currentExampleGroup!.appendAfter { (exampleMetadata: ExampleMetadata) in
            closure()
        }
    }

    public func afterEach(#closure: (exampleMetadata: ExampleMetadata) -> ()) {
        currentExampleGroup!.appendAfter(closure)
    }

    public func it(description: String, file: String, line: Int, closure: () -> ()) {
        let callsite = Callsite(file: file, line: line)
        let example = Example(description, callsite, closure)
        currentExampleGroup!.appendExample(example)
    }

    public func itBehavesLike(name: String, sharedExampleContext: SharedExampleContext, file: String, line: Int) {
        let callsite = Callsite(file: file, line: line)
        let closure = World.sharedWorld().sharedExample(name)

        var group = ExampleGroup(description: name)
        currentExampleGroup!.appendExampleGroup(group)
        currentExampleGroup = group
        closure(sharedExampleContext)
        currentExampleGroup!.walkDownExamples { (example: Example) in
            example.isSharedExample = true
            example.callsite = callsite
        }

        currentExampleGroup = group.parent
    }

    public func pending(description: String, closure: () -> ()) {
        NSLog("Pending: %@", description)
    }
}
