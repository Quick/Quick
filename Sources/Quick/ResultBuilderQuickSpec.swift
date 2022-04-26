
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

extension ExampleGroup {
	func append(specPart: SpecPart) {
		specPart.append(into: self)
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
		let group = ExampleGroup(description: "\(file):\(line)", flags: [:], isInternalRootExampleGroup: false)
		subgroups.forEach(group.append(specPart:))
		return group
	}

//	static func buildFinalResult(_ component: SpecPart) -> ExampleGroup {
//		let rootGroup = ExampleGroup(
//			description: "root example group",
//			flags: [:],
//			isInternalRootExampleGroup: true
//		)
//
//		rootGroup.append(specPart: component)
//
//		return rootGroup
//	}
}

class ResultBuilderQuickSpec: QuickSpec {
	class func createSpecPart() -> ExampleGroup {
		fatalError("Abstract method")
	}

	override func spec() {
//		let rootExampleGroup = createSpecPart()
//		dump(rootExampleGroup)
//		World.sharedWorld.performWithCurrentExampleGroup(rootExampleGroup, closure: {})
	}

	class func describe_builder(_ description: String, flags: FilterFlags = [:], @SpecBuilder builder: () -> SpecPart) -> SpecPart {
		let newGroup = ExampleGroup(description: description, flags: flags)
		newGroup.append(specPart: builder())
		return newGroup
	}

	class func context_builder(_ description: String, flags: FilterFlags = [:], @SpecBuilder builder: () -> SpecPart) -> SpecPart {
		self.describe_builder(description, flags: flags, builder: builder)
	}

	class func it_builder(_ description: String, file: FileString = #file, line: UInt = #line, closure: @escaping () throws -> Void) -> Example {
		let callsite = Callsite(file: file, line: line)
		let example = Example(description: description, callsite: callsite, flags: [:], closure: closure)
		return example
	}
}
