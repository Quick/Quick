import Foundation

public typealias SharedExampleContext = () -> (NSDictionary)
public typealias SharedExampleClosure = (SharedExampleContext) -> ()

public class World: NSObject {
    var _specs: Dictionary<String, ExampleGroup> = [:]

    var _sharedExamples: [String: SharedExampleClosure] = [:]

    internal var suiteHooks = SuiteHooks()

    public var currentExampleGroup: ExampleGroup?

    public var isRunningAdditionalSuites = false

    public func rootExampleGroupForSpecClass(cls: AnyClass) -> ExampleGroup {
        let name = NSStringFromClass(cls)
        if let group = _specs[name] {
            return group
        } else {
            let group = ExampleGroup(description: "root example group",
                                     isInternalRootExampleGroup: true)
            _specs[name] = group
            return group
        }
    }

    var exampleCount: Int {
        get {
            var count = 0
            for (_, group) in _specs {
                group.walkDownExamples { (example: Example) -> () in
                    _ = ++count
                }
            }
            return count
        }
    }

    func registerSharedExample(name: String, closure: SharedExampleClosure) {
        _raiseIfSharedExampleAlreadyRegistered(name)
        _sharedExamples[name] = closure
    }

    func _raiseIfSharedExampleAlreadyRegistered(name: String) {
        if _sharedExamples[name] != nil {
            NSException(name: NSInternalInconsistencyException,
                reason: "A shared example named '\(name)' has already been registered.",
                userInfo: nil).raise()
        }
    }

    func sharedExample(name: String) -> SharedExampleClosure {
        _raiseIfSharedExampleNotRegistered(name)
        return _sharedExamples[name]!
    }

    func _raiseIfSharedExampleNotRegistered(name: String) {
        if _sharedExamples[name] == nil {
            NSException(name: NSInternalInconsistencyException,
                reason: "No shared example named '\(name)' has been registered. Registered shared examples: '\(Array(_sharedExamples.keys))'",
                userInfo: nil).raise()
        }
    }
}
