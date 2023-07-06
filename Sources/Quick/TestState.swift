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
            AsyncWorld.sharedWorld.afterEach { [container] in
                container.value = nil
            }
        }

        if World.sharedWorld.currentExampleGroup != nil {
            World.sharedWorld.afterEach { [container] in
                container.value = nil
            }
        }
    }

    /// Sets the property to an initial value before each test and resets it to nil after each test.
    /// - Parameter initialValue: An autoclosure to return the initial value to use before the test.
    public init(_ initialValue: @escaping @autoclosure () -> T) {
        if AsyncWorld.sharedWorld.currentExampleGroup != nil {
            AsyncWorld.sharedWorld.aroundEach { [container] runExample in
                container.value = initialValue()
                await runExample()
                container.value = nil
            }
        }

        if World.sharedWorld.currentExampleGroup != nil {
            World.sharedWorld.aroundEach { [container] runExample in
                container.value = initialValue()
                runExample()
                container.value = nil
            }
        }
    }
}
