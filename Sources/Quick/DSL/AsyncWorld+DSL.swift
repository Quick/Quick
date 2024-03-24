import Foundation

/**
    Adds methods to World to support top-level DSL functions. These functions map directly to the DSL that test
    writers use in their specs.
*/
extension AsyncWorld {
    // MARK: - Example groups.
    @nonobjc
    internal func describe(_ description: String, flags: FilterFlags = [:], closure: () -> Void) {
        guard currentExampleMetadata == nil else {
            raiseError("'describe' cannot be used inside '\(currentPhase)', 'describe' may only be used inside 'context' or 'describe'.")
        }
        guard currentExampleGroup != nil else {
            // swiftlint:disable:next line_length
            raiseError("Error: example group was not created by its parent QuickSpec spec. Check that describe() or context() was used in QuickSpec.spec() and not a more general context (i.e. an XCTestCase test)")
        }
        let group = AsyncExampleGroup(description: description, flags: flags)
        currentExampleGroup.appendExampleGroup(group)
        performWithCurrentExampleGroup(group, closure: closure)
    }

    @nonobjc
    internal func context(_ description: String, flags: FilterFlags = [:], closure: () -> Void) {
        guard currentExampleMetadata == nil else {
            raiseError("'context' cannot be used inside '\(currentPhase)', 'context' may only be used inside 'context' or 'describe'.")
        }
        self.describe(description, flags: flags, closure: closure)
    }

    @nonobjc
    internal func fdescribe(_ description: String, closure: () -> Void) {
        self.describe(description, flags: [Filter.focused: true], closure: closure)
    }

    @nonobjc
    internal func xdescribe(_ description: String, closure: () -> Void) {
        self.describe(description, flags: [Filter.pending: true], closure: closure)
    }

    // MARK: - Just Before Each
    internal func justBeforeEach(_ closure: @escaping BeforeExampleAsyncClosure) {
        guard currentExampleMetadata == nil else {
            raiseError("'justBeforeEach' cannot be used inside '\(currentPhase)', 'justBeforeEach' may only be used inside 'context' or 'describe'.")
        }
        currentExampleGroup.hooks.appendJustBeforeEach(closure)
    }

    // MARK: - Before Each
    internal func beforeEach(closure: @escaping BeforeExampleWithMetadataAsyncClosure) {
        guard currentExampleMetadata == nil else {
            raiseError("'beforeEach' cannot be used inside '\(currentPhase)', 'beforeEach' may only be used inside 'context' or 'describe'.")
        }
        currentExampleGroup.hooks.appendBefore(closure)
    }

    internal func beforeEach(_ closure: @escaping BeforeExampleAsyncClosure) {
        guard currentExampleMetadata == nil else {
            raiseError("'beforeEach' cannot be used inside '\(currentPhase)', 'beforeEach' may only be used inside 'context' or 'describe'.")
        }
        currentExampleGroup.hooks.appendBefore(closure)
    }

    // MARK: - After Each
    internal func afterEach(closure: @escaping AfterExampleWithMetadataAsyncClosure) {
        guard currentExampleMetadata == nil else {
            raiseError("'afterEach' cannot be used inside '\(currentPhase)', 'afterEach' may only be used inside 'context' or 'describe'.")
        }
        currentExampleGroup.hooks.appendAfter(closure)
    }

    internal func afterEach(_ closure: @escaping AfterExampleAsyncClosure) {
        guard currentExampleMetadata == nil else {
            raiseError("'afterEach' cannot be used inside '\(currentPhase)', 'afterEach' may only be used inside 'context' or 'describe'.")
        }
        currentExampleGroup.hooks.appendAfter(closure)
    }

    // MARK: - Around Each
    internal func aroundEach(_ closure: @escaping AroundExampleAsyncClosure) {
        guard currentExampleMetadata == nil else {
            raiseError("'aroundEach' cannot be used inside '\(currentPhase)', 'aroundEach' may only be used inside 'context' or 'describe'. ")
        }
        currentExampleGroup.hooks.appendAround(closure)
    }

    internal func aroundEach(_ closure: @escaping AroundExampleWithMetadataAsyncClosure) {
        guard currentExampleMetadata == nil else {
            raiseError("'aroundEach' cannot be used inside '\(currentPhase)', 'aroundEach' may only be used inside 'context' or 'describe'. ")
        }
        currentExampleGroup.hooks.appendAround(closure)
    }

    // MARK: - Examples (Swift)
    @nonobjc
    internal func it(_ description: String, flags: FilterFlags = [:], file: FileString, line: UInt, closure: @escaping () async throws -> Void) {
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
        let example = AsyncExample(description: description, callsite: callsite, flags: flags, closure: closure)
        currentExampleGroup.appendExample(example)
    }

    @nonobjc
    internal func fit(_ description: String, file: FileString, line: UInt, closure: @escaping () async throws -> Void) {
        self.it(description, flags: [Filter.focused: true], file: file, line: line, closure: closure)
    }

    @nonobjc
    internal func xit(_ description: String, file: FileString, line: UInt, closure: @escaping () async throws -> Void) {
        self.it(description, flags: [Filter.pending: true], file: file, line: line, closure: closure)
    }

    // MARK: - Shared Behavior
    internal func itBehavesLike<C>(_ behavior: AsyncBehavior<C>.Type, context: @escaping () -> C, flags: FilterFlags = [:], file: FileString, line: UInt) {
        guard currentExampleMetadata == nil else {
            raiseError("'itBehavesLike' cannot be used inside '\(currentPhase)', 'itBehavesLike' may only be used inside 'context' or 'describe'.")
        }
        let callsite = Callsite(file: file, line: line)
        let closure = behavior.spec
        let group = AsyncExampleGroup(description: behavior.name, flags: flags)
        currentExampleGroup.appendExampleGroup(group)
        performWithCurrentExampleGroup(group) {
            closure(context)
        }

        group.walkDownExamples { (example: AsyncExample) in
            example.isSharedExample = true
            example.callsite = callsite
        }
    }

    internal func fitBehavesLike<C>(_ behavior: AsyncBehavior<C>.Type, context: @escaping () -> C, file: FileString, line: UInt) {
        self.itBehavesLike(behavior, context: context, flags: [Filter.focused: true], file: file, line: line)
    }

    internal func xitBehavesLike<C>(_ behavior: AsyncBehavior<C>.Type, context: @escaping () -> C, file: FileString, line: UInt) {
        self.itBehavesLike(behavior, context: context, flags: [Filter.pending: true], file: file, line: line)
    }

    // MARK: - Pending
    @nonobjc
    internal func pending(_ description: String, file: FileString, line: UInt, closure: @escaping () async throws -> Void) {
        self.it(description, flags: [Filter.pending: true], file: file, line: line, closure: closure)
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
