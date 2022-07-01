import Foundation

/**
    Adds methods to World to support top-level DSL functions (Swift) and
    macros (Objective-C). These functions map directly to the DSL that test
    writers use in their specs.
*/
extension World {
#if canImport(Darwin)
    @objc(beforeSuite:)
    internal func objc_beforeSuite(_ closure: @escaping BeforeSuiteSyncClosure) {
        suiteHooks.appendBefore(closure)
    }
#endif

    @nonobjc
    internal func beforeSuite(_ closure: @escaping BeforeSuiteClosure) {
        suiteHooks.appendBefore(closure)
    }

#if canImport(Darwin)
    @objc(afterSuite:)
    internal func afterSuite(_ closure: @escaping AfterSuiteSyncClosure) {
        suiteHooks.appendAfter(closure)
    }
#endif

    @nonobjc
    internal func afterSuite(_ closure: @escaping AfterSuiteClosure) {
        suiteHooks.appendAfter(closure)
    }

    internal func sharedExamples(_ name: String, closure: @escaping SharedExampleClosure) {
        registerSharedExample(name, closure: closure)
    }

    internal func describe(_ description: String, flags: FilterFlags = [:], closure: () -> Void) {
        guard currentExampleMetadata == nil else {
            raiseError("'describe' cannot be used inside '\(currentPhase)', 'describe' may only be used inside 'context' or 'describe'.")
        }
        guard currentExampleGroup != nil else {
            // swiftlint:disable:next line_length
            raiseError("Error: example group was not created by its parent QuickSpec spec. Check that describe() or context() was used in QuickSpec.spec() and not a more general context (i.e. an XCTestCase test)")
        }
        let group = ExampleGroup(description: description, flags: flags)
        currentExampleGroup.appendExampleGroup(group)
        performWithCurrentExampleGroup(group, closure: closure)
    }

    internal func context(_ description: String, flags: FilterFlags = [:], closure: () -> Void) {
        guard currentExampleMetadata == nil else {
            raiseError("'context' cannot be used inside '\(currentPhase)', 'context' may only be used inside 'context' or 'describe'.")
        }
        self.describe(description, flags: flags, closure: closure)
    }

    internal func fdescribe(_ description: String, closure: () -> Void) {
        self.describe(description, flags: [Filter.focused: true], closure: closure)
    }

    internal func xdescribe(_ description: String, closure: () -> Void) {
        self.describe(description, flags: [Filter.pending: true], closure: closure)
    }

#if canImport(Darwin)
    @objc(beforeEachWithMetadata:)
    internal func objc_beforeEach(closure: @escaping BeforeExampleWithMetadataSyncClosure) {
        currentExampleGroup.hooks.appendBefore(closure)
    }

    @objc(beforeEach:)
    internal func objc_beforeEach(_ closure: @escaping BeforeExampleSyncClosure) {
        guard currentExampleMetadata == nil else {
            raiseError("'beforeEach' cannot be used inside '\(currentPhase)', 'beforeEach' may only be used inside 'context' or 'describe'.")
        }
        currentExampleGroup.hooks.appendBefore(closure)
    }
#endif

    @nonobjc
    internal func beforeEach(_ closure: @escaping BeforeExampleClosure) {
        guard currentExampleMetadata == nil else {
            raiseError("'beforeEach' cannot be used inside '\(currentPhase)', 'beforeEach' may only be used inside 'context' or 'describe'.")
        }
        currentExampleGroup.hooks.appendBefore(closure)
    }

    @nonobjc
    internal func beforeEach(closure: @escaping BeforeExampleWithMetadataClosure) {
        currentExampleGroup.hooks.appendBefore(closure)
    }

#if canImport(Darwin)
    @objc(afterEachWithMetadata:)
    internal func objc_afterEach(closure: @escaping AfterExampleWithMetadataSyncClosure) {
        currentExampleGroup.hooks.appendAfter(closure)
    }

    @objc(afterEach:)
    internal func objc_afterEach(_ closure: @escaping AfterExampleSyncClosure) {
        guard currentExampleMetadata == nil else {
            raiseError("'afterEach' cannot be used inside '\(currentPhase)', 'afterEach' may only be used inside 'context' or 'describe'.")
        }
        currentExampleGroup.hooks.appendAfter(closure)
    }
#endif

    @nonobjc
    internal func afterEach(_ closure: @escaping AfterExampleClosure) {
        guard currentExampleMetadata == nil else {
            raiseError("'afterEach' cannot be used inside '\(currentPhase)', 'afterEach' may only be used inside 'context' or 'describe'.")
        }
        currentExampleGroup.hooks.appendAfter(closure)
    }

    @nonobjc
    internal func afterEach(closure: @escaping AfterExampleWithMetadataClosure) {
        currentExampleGroup.hooks.appendAfter(closure)
    }

#if canImport(Darwin)
    @objc(aroundEachWithMetadata:)
    internal func objc_aroundEach(_ closure: @escaping AroundExampleWithMetadataSyncClosure) {
        currentExampleGroup.hooks.appendAroundSync(closure)
    }

    @objc(aroundEach:)
    internal func objc_aroundEach(_ closure: @escaping AroundExampleSyncClosure) {
        guard currentExampleMetadata == nil else {
            raiseError("'aroundEach' cannot be used inside '\(currentPhase)', 'aroundEach' may only be used inside 'context' or 'describe'. ")
        }
        currentExampleGroup.hooks.appendAroundSync(closure)
    }
#endif
    @nonobjc
    internal func aroundEach(_ closure: @escaping AroundExampleClosure) {
        guard currentExampleMetadata == nil else {
            raiseError("'aroundEach' cannot be used inside '\(currentPhase)', 'aroundEach' may only be used inside 'context' or 'describe'. ")
        }
        currentExampleGroup.hooks.appendAround(closure)
    }

    @nonobjc
    internal func aroundEach(_ closure: @escaping AroundExampleWithMetadataClosure) {
        currentExampleGroup.hooks.appendAround(closure)
    }

    @nonobjc
    internal func it(_ description: String, flags: FilterFlags = [:], file: FileString, line: UInt, closure: @Sendable @escaping () async throws -> Void) {
        if beforesCurrentlyExecuting {
            raiseError("'it' cannot be used inside 'beforeEach', 'it' may only be used inside 'context' or 'describe'.")
        }
        if aftersCurrentlyExecuting {
            raiseError("'it' cannot be used inside 'afterEach', 'it' may only be used inside 'context' or 'describe'.")
        }
        guard currentExampleMetadata == nil else {
            raiseError("'it' cannot be used inside 'it', 'it' may only be used inside 'context' or 'describe'.")
        }
        let callsite = Callsite(file: file, line: line)
        let example = Example(description: description, callsite: callsite, flags: flags, closure: closure)
        currentExampleGroup.appendExample(example)
    }

    @nonobjc
    internal func fit(_ description: String, file: FileString, line: UInt, closure: @Sendable @escaping () async throws -> Void) {
        self.it(description, flags: [Filter.focused: true], file: file, line: line, closure: closure)
    }

    @nonobjc
    internal func xit(_ description: String, file: FileString, line: UInt, closure: @Sendable @escaping () async throws -> Void) {
        self.it(description, flags: [Filter.pending: true], file: file, line: line, closure: closure)
    }

    @nonobjc
    internal func itBehavesLike(_ name: String, sharedExampleContext: @escaping SharedExampleContext, flags: FilterFlags = [:], file: FileString, line: UInt) {
        guard currentExampleMetadata == nil else {
            raiseError("'itBehavesLike' cannot be used inside '\(currentPhase)', 'itBehavesLike' may only be used inside 'context' or 'describe'.")
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

    @nonobjc
    internal func fitBehavesLike(_ name: String, sharedExampleContext: @escaping SharedExampleContext, file: FileString, line: UInt) {
        self.itBehavesLike(name, sharedExampleContext: sharedExampleContext, flags: [Filter.focused: true], file: file, line: line)
    }

    @nonobjc
    internal func xitBehavesLike(_ name: String, sharedExampleContext: @escaping SharedExampleContext, file: FileString, line: UInt) {
        self.itBehavesLike(name, sharedExampleContext: sharedExampleContext, flags: [Filter.pending: true], file: file, line: line)
    }

    internal func itBehavesLike<C>(_ behavior: Behavior<C>.Type, context: @escaping () -> C, flags: FilterFlags = [:], file: FileString, line: UInt) {
        guard currentExampleMetadata == nil else {
            raiseError("'itBehavesLike' cannot be used inside '\(currentPhase)', 'itBehavesLike' may only be used inside 'context' or 'describe'.")
        }
        let callsite = Callsite(file: file, line: line)
        let closure = behavior.spec
        let group = ExampleGroup(description: behavior.name, flags: flags)
        currentExampleGroup.appendExampleGroup(group)
        performWithCurrentExampleGroup(group) {
            closure(context)
        }

        group.walkDownExamples { (example: Example) in
            example.isSharedExample = true
            example.callsite = callsite
        }
    }

    internal func fitBehavesLike<C>(_ behavior: Behavior<C>.Type, context: @escaping () -> C, file: FileString, line: UInt) {
        self.itBehavesLike(behavior, context: context, flags: [Filter.focused: true], file: file, line: line)
    }

    internal func xitBehavesLike<C>(_ behavior: Behavior<C>.Type, context: @escaping () -> C, file: FileString, line: UInt) {
        self.itBehavesLike(behavior, context: context, flags: [Filter.pending: true], file: file, line: line)
    }

#if canImport(Darwin) && !SWIFT_PACKAGE
    @objc(itWithDescription:file:line:closure:)
    internal func objc_it(_ description: String, file: FileString, line: UInt, closure: @Sendable @escaping () -> Void) {
        it(description, file: file, line: line, closure: closure)
    }

    @objc(fitWithDescription:file:line:closure:)
    internal func objc_fit(_ description: String, file: FileString, line: UInt, closure: @Sendable @escaping () -> Void) {
        fit(description, file: file, line: line, closure: closure)
    }

    @objc(xitWithDescription:file:line:closure:)
    internal func objc_xit(_ description: String, file: FileString, line: UInt, closure: @Sendable @escaping () -> Void) {
        xit(description, file: file, line: line, closure: closure)
    }

    @objc(itBehavesLikeSharedExampleNamed:sharedExampleContext:file:line:)
    internal func objc_itBehavesLike(_ name: String, sharedExampleContext: @escaping SharedExampleContext, file: FileString, line: UInt) {
        itBehavesLike(name, sharedExampleContext: sharedExampleContext, file: file, line: line)
    }

    @objc(fitBehavesLikeSharedExampleNamed:sharedExampleContext:file:line:)
    internal func objc_fitBehavesLike(_ name: String, sharedExampleContext: @escaping SharedExampleContext, file: FileString, line: UInt) {
        fitBehavesLike(name, sharedExampleContext: sharedExampleContext, file: file, line: line)
    }

    @objc(xitBehavesLikeSharedExampleNamed:sharedExampleContext:file:line:)
    internal func objc_xitBehavesLike(_ name: String, sharedExampleContext: @escaping SharedExampleContext, file: FileString, line: UInt) {
        xitBehavesLike(name, sharedExampleContext: sharedExampleContext, file: file, line: line)
    }
#endif

    internal func pending(_ description: String, closure: () -> Void) {
        print("Pending: \(description)")
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
