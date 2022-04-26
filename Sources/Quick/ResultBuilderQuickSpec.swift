struct Spec {
	let rootGroup: ExampleGroup

	init(@SpecBuilder builder: () -> ExampleGroup) {
		self.rootGroup = builder()
	}
}

protocol SpecPart {
	func append(into: ExampleGroup)
}

extension ExampleGroup: SpecPart {
	func append(into group: ExampleGroup) {
		group.appendExampleGroup(self)
	}
}

extension Example: SpecPart {
	func append(into group: ExampleGroup) {
		group.appendExample(self)
	}
}

struct Statement: SpecPart {
	let closure: () -> Void

	func append(into group: ExampleGroup) {
		group.hooks.appendBefore(self.closure)
	}
}

@resultBuilder
enum SpecBuilder {
	static func buildExpression(_ expression: SpecPart) -> SpecPart {
		expression
	}

	// This allows statements (like assignments to variables) to be contained directly in the result builder call
	static func buildExpression(_ expression: @escaping @autoclosure () -> Void) -> SpecPart {
		Statement(closure: expression)
	}

	static func buildBlock(_ subgroups: SpecPart..., file: StaticString = #file, line: UInt = #line) -> SpecPart {
		// TODO: Can we elide these intermediate groups somehow?
		let newGroup = ExampleGroup(description: "\(file):\(line)", flags: [:], isInternalRootExampleGroup: false)
		subgroups.forEach { $0.append(into: newGroup) }
		return newGroup
	}

	static func buildFinalResult(_ component: SpecPart) -> ExampleGroup {
		let rootGroup = ExampleGroup(
			description: "root example group",
			flags: [:],
			isInternalRootExampleGroup: true
		)

		component.append(into: rootGroup)

		return rootGroup
	}
}

@resultBuilder
enum SpecPartBuilder {
	static func buildExpression(_ expression: SpecPart) -> SpecPart {
		expression
	}

	// This allows statements (like assignments to variables) to be contained directly in the result builder call
	// These will all be turned into `beforeEach` hooks.
	static func buildExpression(_ expression: @escaping @autoclosure () -> Void) -> SpecPart {
		Statement(closure: expression)
	}

	static func buildBlock(_ subgroups: SpecPart..., file: StaticString = #file, line: UInt = #line) -> SpecPart {
		// TODO: Can we elide these intermediate groups somehow?
		let newGroup = ExampleGroup(description: "\(file):\(line)", flags: [:], isInternalRootExampleGroup: false)
		subgroups.forEach { $0.append(into: newGroup) }
		return newGroup
	}
}

class ResultBuilderQuickSpec: QuickSpec {
	open class func spec() -> Spec {
		fatalError("Abstract method")
	}

	class func describe_builder(_ description: String, flags: FilterFlags = [:], @SpecPartBuilder builder: () -> SpecPart) -> SpecPart {
		let newGroup = ExampleGroup(description: description, flags: flags)

		let newSpecPart = builder()
		newSpecPart.append(into: newGroup)

		return newGroup
	}

	class func context_builder(_ description: String, flags: FilterFlags = [:], @SpecPartBuilder builder: () -> SpecPart) -> SpecPart {
		self.describe_builder(description, flags: flags, builder: builder)
	}

	class func it_builder(_ description: String, file: FileString = #file, line: UInt = #line, closure: @escaping () throws -> Void) -> Example {
		let callsite = Callsite(file: file, line: line)
		let example = Example(description: description, callsite: callsite, flags: [:], closure: closure)
		return example
	}
}
