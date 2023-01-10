extension AsyncSpec {
    public class func describe(_ description: String, @AsyncGroupBuilder children: () -> [QuickAsync]) -> AsyncExampleGroup {
        AsyncExampleGroup(description, children: children)
    }

    public class func context(_ description: String, @AsyncGroupBuilder children: () -> [QuickAsync]) -> AsyncExampleGroup {
        AsyncExampleGroup(description, children: children)
    }

    public class func beforeEach(closure: @escaping () async throws -> Void) -> BeforeEach {
        BeforeEach(closure: closure)
    }

    public class func afterEach(closure: @escaping () async throws -> Void) -> AfterEach {
        AfterEach(closure: closure)
    }

    public class func it(_ description: String, file: FileString = #file, line: UInt = #line, closure: @escaping () async throws -> Void) -> It {
        It(description, file: file, line: line, closure: closure)
    }
}
