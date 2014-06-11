// Playground - noun: a place where people can play

import Cocoa

"goodbye"

enum MyOptional<T> : LogicValue {
    case None
    case Some(T)

    func getLogicValue() -> Bool {
        switch self {
        case .None:
            return false

        default:
            return true
        }
    }
}

func decode(value: MyOptional<Any>) -> String {

    switch value {

    case .None:

        return "None"

    case .Some(let val):

        return "Some"

    }

}

var opt: MyOptional<Any> = .Some(1)

decode(MyOptional<Any>.None)
decode(MyOptional<Any>.Some(1))
decode(MyOptional<Any>.Some("ABC"))


if opt {
    "Set"
} else {
    "Not Set"
}

