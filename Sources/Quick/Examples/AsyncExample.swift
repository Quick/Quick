@resultBuilder
public struct AsyncSpecBuilder {
    typealias FinalResult = [AsyncExample]
    public static func buildBlock(_ components: QuickAsync...) -> QuickAsync {
        Describe(description: "", flags: [:], isInternalRootExampleGroup: true, children: components)
    }

    public static func buildFinalResult(_ component: QuickAsync) -> [AsyncExample] {
        component.component.group()
            .map { (name, callsite, closure) in
            return AsyncExample(name: name, callsite: callsite, closure: closure)
        }
    }
}

@resultBuilder
public struct AsyncGroupBuilder {
    public static func buildBlock(_ components: QuickAsync...) -> [QuickAsync] {
        components
    }

    public static func buildArray(_ components: [[QuickAsync]]) -> [QuickAsync] {
        components.flatMap { $0 }
    }
}

public final class AsyncExample: ExampleBase {
    fileprivate let closure: () async throws -> Void

    internal init(name: String, callsite: Callsite, closure: @escaping () async throws -> Void) {
        self.closure = closure
        super.init(name: name, callsite: callsite)
    }

    internal func run() async {
        do {
            try await closure()
        } catch {
            self.handleThrownErrorFromTest(error: error)
        }
    }
}

public indirect enum AsyncComponent {
    case beforeEach(closure: () async throws -> Void)
    case example(name: String, callsite: Callsite, closure: () async throws -> Void)
    case afterEach(closure: () async throws -> Void)
    case describe(AsyncExampleGroup)

    func group() -> [(name: String, callsite: Callsite, closure: () async throws -> Void)] { // swiftlint:disable:this large_tuple
        switch self {
        case .beforeEach, .afterEach: return []
        case let .example(name: name, callsite: callsite, closure: closure):
            return [(name, callsite, closure)]
        case let .describe(exampleGroup):
            let components = exampleGroup.children.map { $0.component }
            let beforeEachs = components.compactMap { $0.beforeEach }
            let afterEachs = components.compactMap { $0.afterEach }

            return components.flatMap { subComponent in
                return subComponent.group().map { (subname, callsite, closure) in
                    var exampleName: String
                    if exampleGroup.isInternalRootExampleGroup {
                        exampleName = subname
                    } else {
                        exampleName = "\(exampleGroup.description) \(subname)"
                    }
                    return (exampleName, callsite, {
                        for beforeEach in beforeEachs {
                            try await beforeEach()
                        }

                        try await closure()

                        for afterEach in afterEachs {
                            try await afterEach()
                        }
                    })
                }
            }
        }
    }

    private var beforeEach: (() async throws -> Void)? {
        guard case let .beforeEach(closure) = self else {
            return nil
        }
        return closure
    }

    private var afterEach: (() async throws -> Void)? {
        guard case let .afterEach(closure) = self else {
            return nil
        }
        return closure
    }
}

public protocol QuickAsync {
//    var exampleGroup: AsyncExampleGroup { get }
    var component: AsyncComponent { get }
}

public struct It: QuickAsync { // swiftlint:disable:this type_name
    let name: String
    let callsite: Callsite
    let closure: () async throws -> Void

    public var component: AsyncComponent {
        .example(name: name, callsite: callsite, closure: closure)
    }
    public init(_ description: String, file: FileString = #file, line: UInt = #line, closure: @escaping () async throws -> Void) {
        name = description
        callsite = Callsite(file: file, line: line)
        self.closure = closure
    }
}

public struct BeforeEach: QuickAsync {
    internal let closure: () async throws -> Void

    public var component: AsyncComponent { .beforeEach(closure: closure) }

    public init(closure: @escaping () async throws -> Void) {
        self.closure = closure
    }
}

public struct AfterEach: QuickAsync {
    internal let closure: () async throws -> Void

    public var component: AsyncComponent { .afterEach(closure: closure) }

    public init(closure: @escaping () async throws -> Void) {
        self.closure = closure
    }
}

public struct AsyncExampleGroup {
    let description: String
    let flags: FilterFlags
    let isInternalRootExampleGroup: Bool
    let children: [QuickAsync]

    internal init(description: String, flags: FilterFlags, isInternalRootExampleGroup: Bool, children: [QuickAsync]) {
        self.description = description
        self.flags = flags
        self.isInternalRootExampleGroup = isInternalRootExampleGroup
        self.children = children
    }

    public init(_ description: String, @AsyncGroupBuilder children: () -> [QuickAsync]) {
        self.description = description
        self.flags = [:]
        self.isInternalRootExampleGroup = false
        self.children = children()
    }
}

public typealias Describe = AsyncExampleGroup
public typealias Context = AsyncExampleGroup

extension AsyncExampleGroup: QuickAsync {
    public var component: AsyncComponent {
        .describe(self)
    }
}
