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
                TestStateConfiguration.afterEach.append {
                    container.value = nil
                }
            }
        }

        if World.sharedWorld.currentExampleGroup != nil {
            World.sharedWorld.beforeEach { [container] in
                TestStateConfiguration.afterEach.append {
                    container.value = nil
                }
            }
        }
    }

    public init(wrappedValue: @escaping @autoclosure () -> T?) {
        if AsyncWorld.sharedWorld.currentExampleGroup != nil {
            AsyncWorld.sharedWorld.beforeEach { [container] in
                container.value = wrappedValue()
                TestStateConfiguration.afterEach.append {
                    container.value = nil
                }
            }
        }

        if World.sharedWorld.currentExampleGroup != nil {
            World.sharedWorld.beforeEach { [container] in
                container.value = wrappedValue()
                TestStateConfiguration.afterEach.append {
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

private final class TestStateConfiguration: QuickConfiguration {
    static var afterEach: [() -> Void] = []

    override class func configure(_ configuration: QCKConfiguration) {
        configuration.afterEach {
            afterEach.forEach { $0() }
            afterEach = []
        }
    }
}
