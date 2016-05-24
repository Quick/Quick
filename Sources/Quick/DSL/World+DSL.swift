import Foundation

/**
    Adds methods to World to support top-level DSL functions (Swift) and
    macros (Objective-C). These functions map directly to the DSL that test
    writers use in their specs.
*/
extension World {
    internal func beforeSuite(closure: BeforeSuiteClosure) {
        suiteHooks.appendBefore(closure)
    }

    internal func afterSuite(closure: AfterSuiteClosure) {
        suiteHooks.appendAfter(closure)
    }

    internal func sharedExamples(name: String, closure: SharedExampleClosure) {
        registerSharedExample(name, closure: closure)
    }

    internal func describe(description: String, flags: FilterFlags, closure: () -> ()) {
        guard currentExampleMetadata == nil else {
            raiseError("'describe' cannot be used inside '\(currentPhase)', 'describe' may only be used inside 'context' or 'describe'. ")
        }
        guard currentExampleGroup != nil else {
            raiseError("Error: example group was not created by its parent QuickSpec spec. Check that describe() or context() was used in QuickSpec.spec() and not a more general context (i.e. an XCTestCase test)")
        }
        let group = ExampleGroup(description: description, flags: flags)
        currentExampleGroup.appendExampleGroup(group)
        performWithCurrentExampleGroup(group, closure: closure)
    }

    internal func context(description: String, flags: FilterFlags, closure: () -> ()) {
        guard currentExampleMetadata == nil else {
            raiseError("'context' cannot be used inside '\(currentPhase)', 'context' may only be used inside 'context' or 'describe'. ")
        }
        self.describe(description, flags: flags, closure: closure)
    }

    internal func fdescribe(description: String, flags: FilterFlags, closure: () -> ()) {
        var focusedFlags = flags
        focusedFlags[Filter.focused] = true
        self.describe(description, flags: focusedFlags, closure: closure)
    }

    internal func xdescribe(description: String, flags: FilterFlags, closure: () -> ()) {
        var excludedFlags = flags
        excludedFlags[Filter.excluded] = true
        self.describe(description, flags: excludedFlags, closure: closure)
    }

    internal func beforeEach(closure: BeforeExampleClosure) {
        guard currentExampleMetadata == nil else {
            raiseError("'beforeEach' cannot be used inside '\(currentPhase)', 'beforeEach' may only be used inside 'context' or 'describe'. ")
        }
        currentExampleGroup.hooks.appendBefore(closure)
    }

#if _runtime(_ObjC)
    @objc(beforeEachWithMetadata:)
    internal func beforeEach(closure closure: BeforeExampleWithMetadataClosure) {
        currentExampleGroup.hooks.appendBefore(closure)
    }
#else
    internal func beforeEach(closure closure: BeforeExampleWithMetadataClosure) {
        currentExampleGroup.hooks.appendBefore(closure)
    }
#endif

    internal func afterEach(closure: AfterExampleClosure) {
        guard currentExampleMetadata == nil else {
            raiseError("'afterEach' cannot be used inside '\(currentPhase)', 'afterEach' may only be used inside 'context' or 'describe'. ")
        }
        currentExampleGroup.hooks.appendAfter(closure)
    }

#if _runtime(_ObjC)
    @objc(afterEachWithMetadata:)
    internal func afterEach(closure closure: AfterExampleWithMetadataClosure) {
        currentExampleGroup.hooks.appendAfter(closure)
    }
#else
    internal func afterEach(closure closure: AfterExampleWithMetadataClosure) {
        currentExampleGroup.hooks.appendAfter(closure)
    }
#endif

    internal func it(description: String, flags: FilterFlags, file: String, line: UInt, closure: () -> ()) {
        if beforesCurrentlyExecuting {
            raiseError("'it' cannot be used inside 'beforeEach', 'it' may only be used inside 'context' or 'describe'. ")
        }
        if aftersCurrentlyExecuting {
            raiseError("'it' cannot be used inside 'afterEach', 'it' may only be used inside 'context' or 'describe'. ")
        }
        guard currentExampleMetadata == nil else {
            raiseError("'it' cannot be used inside 'it', 'it' may only be used inside 'context' or 'describe'. ")
        }
        let callsite = Callsite(file: file, line: line)
        let example = Example(description: description, callsite: callsite, flags: flags, closure: closure)
        currentExampleGroup.appendExample(example)
    }

    internal func fit(description: String, flags: FilterFlags, file: String, line: UInt, closure: () -> ()) {
        var focusedFlags = flags
        focusedFlags[Filter.focused] = true
        self.it(description, flags: focusedFlags, file: file, line: line, closure: closure)
    }

    internal func xit(description: String, flags: FilterFlags, file: String, line: UInt, closure: () -> ()) {
        var excludedFlags = flags
        excludedFlags[Filter.excluded] = true
        self.it(description, flags: excludedFlags, file: file, line: line, closure: closure)
    }

    internal func itBehavesLike(name: String, sharedExampleContext: SharedExampleContext, flags: FilterFlags, file: String, line: UInt) {
        guard currentExampleMetadata == nil else {
            raiseError("'itBehavesLike' cannot be used inside '\(currentPhase)', 'itBehavesLike' may only be used inside 'context' or 'describe'. ")
        }
        let callsite = Callsite(file: file, line: line)
        let closure = World.sharedWorld.sharedExample(name)

        let group = ExampleGroup(description: name, flags: flags)
        currentExampleGroup.appendExampleGroup(group)
        performWithCurrentExampleGroup(group) {
            closure(sharedExampleContext)
        }

        group.walkDownExamples { (example: Example) in
            example.isSharedExample = true
            example.callsite = callsite
        }
    }

#if _runtime(_ObjC)
    @objc(itWithDescription:flags:file:line:closure:)
    private func objc_it(description: String, flags: FilterFlags, file: String, line: UInt, closure: () -> ()) {
        it(description, flags: flags, file: file, line: line, closure: closure)
    }

    @objc(fitWithDescription:flags:file:line:closure:)
    private func objc_fit(description: String, flags: FilterFlags, file: String, line: UInt, closure: () -> ()) {
        fit(description, flags: flags, file: file, line: line, closure: closure)
    }

    @objc(xitWithDescription:flags:file:line:closure:)
    private func objc_xit(description: String, flags: FilterFlags, file: String, line: UInt, closure: () -> ()) {
        xit(description, flags: flags, file: file, line: line, closure: closure)
    }

    @objc(itBehavesLikeSharedExampleNamed:sharedExampleContext:flags:file:line:)
    private func objc_itBehavesLike(name: String, sharedExampleContext: SharedExampleContext, flags: FilterFlags, file: String, line: UInt) {
        itBehavesLike(name, sharedExampleContext: sharedExampleContext, flags: flags, file: file, line: line)
    }
#endif

    internal func pending(description: String, flags: FilterFlags, file: String, line: UInt, closure: () -> ()) {
        var pendingFlags = flags
        pendingFlags[Filter.pending] = true
        self.it(description, flags: pendingFlags, file: file, line: line, closure: closure)
    }

    private var currentPhase: String {
        if beforesCurrentlyExecuting {
            return "beforeEach"
        } else if aftersCurrentlyExecuting {
            return "afterEach"
        }

        return "it"
    }
}
