import Testing

public protocol Spec: Sendable {
    @SpecBuilder var body: Behavior { get }
}

@resultBuilder
public struct SpecBuilder {
    typealias FinalResult = Behavior

    public static func buildBlock(_ components: Behavior...) -> [Behavior] {
        components
    }

    public static func buildFinalResult(_ component: [any Behavior]) -> Behavior {
        AnonymousExampleGroup(behaviors: component)
    }
}

public struct Example: Sendable {
    public let name: String
    public let sourceLocation: SourceLocation
    public let closure: @Sendable () async throws -> Void

    func addToExampleGroup(named: String) -> Example {
        Example(
            name: [named, name].joined(separator: ", "),
            sourceLocation: sourceLocation,
            closure: closure
        )
    }
}

public protocol Behavior: Sendable {
    var examples: [Example] { get }
}

struct ExampleGroup: Behavior {
    let behavior: @Sendable () -> Behavior
    let name: String

    init(_ name: String, @SpecBuilder behavior: @escaping @Sendable () -> Behavior) {
        self.name = name
        self.behavior = behavior
    }

    var examples: [Example] {
        behavior().examples.map {
            $0.addToExampleGroup(named: name)
        }
    }
}

struct AnonymousExampleGroup: Behavior {
    let behaviors: [Behavior]

    init(behaviors: [Behavior]) {
        self.behaviors = behaviors
    }

    var examples: [Example] {
        behaviors.flatMap { $0.examples }
    }
}

struct SynchronousExample: Behavior {
    let name: String
    let sourceLocation: SourceLocation
    let example: @MainActor @Sendable () throws -> Void

    var examples: [Example] {
        [
            Example(name: name, sourceLocation: sourceLocation) {
                try await MainActor.run {
                    try self.example()
                }
            }
        ]
    }
}

struct AsynchronousExample: Behavior {
    let name: String
    let sourceLocation: SourceLocation
    let example: @Sendable () async throws -> Void

    var examples: [Example] {
        [
            Example(name: name, sourceLocation: sourceLocation) {
                try await self.example()
            }
        ]
    }
}

@discardableResult
public func describe(_ name: String, @SpecBuilder behavior: @escaping @Sendable () -> Behavior) -> Behavior {
    ExampleGroup(name, behavior: behavior)
}

@discardableResult
public func it(
    _ name: String,
    sourceLocation: SourceLocation = Testing.SourceLocation(),
    example: @escaping @MainActor @Sendable () throws -> Void
) -> Behavior {
    SynchronousExample(
        name: name,
        sourceLocation: sourceLocation,
        example: example
    )
}

@discardableResult
public func asyncIt(
    _ name: String,
    sourceLocation: SourceLocation = Testing.SourceLocation(),
    example: @escaping @Sendable () async throws -> Void
) -> Behavior {
    AsynchronousExample(
        name: name,
        sourceLocation: sourceLocation,
        example: example
    )
}
