public typealias DefinitionClosure = () -> AnyObject

/**
A container for variable definitions in example groups
*/
final internal class Definitions {
    
    private var closures = [String: DefinitionClosure]()
    private var memoizedValues = [String: AnyObject]()
    
    internal func define(name: String, closure: DefinitionClosure) {
        closures[name] = closure
    }
    
    internal func fetch(name: String) -> AnyObject? {
        if let memoizedValue: AnyObject = memoizedValues[name] {
            return memoizedValue
        }
        if let closure = closures[name] {
            let computedValue: AnyObject = closure()
            memoizedValues[name] = computedValue
            return computedValue
        }
        return nil
    }
    
    internal func clearMemoizedValues() {
        memoizedValues.removeAll(keepCapacity: false)
    }
}
