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
        if !contains(closures.keys, name) {
            return nil
        }
        if let memoizedValue: AnyObject = memoizedValues[name] {
            return memoizedValue
        }
        let computedValue: AnyObject = closures[name]!()
        memoizedValues[name] = computedValue
        return computedValue
    }
    
    internal func clearMemoizedValues() {
        memoizedValues.removeAll(keepCapacity: false)
    }
}
