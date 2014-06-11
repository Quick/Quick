// Playground - noun: a place where people can play

import Cocoa

class Stack<T> {

    var items: T[] = []

    init() {

    }

    func push(item: T) {

        items.append(item)

    }

    func pop() -> T {

        return items.removeLast()

    }

}

var stack = Stack<Int>()

stack.push(1)
stack.push(2)

stack.pop()
stack.pop()

stack


struct EqualMatcher<T: Equatable> {

    let expected: T

    init(_ expect: T) {
        expected = expect
    }

    func isEqualTo(actual: T) -> Bool {

        return expected == actual

    }

}