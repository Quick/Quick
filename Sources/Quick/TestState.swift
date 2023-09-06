/// A property wrapper that will automatically reset the contained value after each test.
@propertyWrapper
public struct TestState<T> {
    private class Container {
        var value: T?
    }

    private let container = Container()

    public var wrappedValue: T! {
        get { container.value }
        set { container.value = newValue }
    }

    /// Resets the property to nil after each test.
    public init() {
        if AsyncWorld.sharedWorld.currentExampleGroup != nil {
            AsyncWorld.sharedWorld.beforeEach { [container] in
                AsyncSpec.current.addTeardownBlock {
                    container.value = nil
                }
            }
        }

        if World.sharedWorld.currentExampleGroup != nil {
            World.sharedWorld.beforeEach { [container] in
                QuickSpec.current.addTeardownBlock {
                    container.value = nil
                }
            }
        }
    }

    public init(wrappedValue: @escaping @autoclosure () -> T?) {
        if AsyncWorld.sharedWorld.currentExampleGroup != nil {
            AsyncWorld.sharedWorld.beforeEach { [container] in
                container.value = wrappedValue()
                AsyncSpec.current.addTeardownBlock {
                    container.value = nil
                }
            }
        }

        if World.sharedWorld.currentExampleGroup != nil {
            World.sharedWorld.beforeEach { [container] in
                container.value = wrappedValue()
                QuickSpec.current.addTeardownBlock {
                    container.value = nil
                }
            }
        }
    }

    /// Sets the property to an initial value before each test and resets it to nil after each test.
    /// - Parameter initialValue: An autoclosure to return the initial value to use before the test.
    public init(_ initialValue: @escaping @autoclosure () -> T) {
        self.init(wrappedValue: initialValue())
    }
}
