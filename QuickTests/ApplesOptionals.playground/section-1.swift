// Playground - noun: a place where people can play

import Foundation

func f(actual: Any?) -> Bool {

    if actual {
        return false
    }
    return true

}

f(nil)      // returns false - FAIL

var optVal: Any?

f(optVal)   // returns false - FAIL

optVal = "Hello"

f(optVal)   // return false - PASS

var strVal: String?

f(strVal)   // return true - PASS

strVal = "World"

f(strVal)   // return false - PASS
f(true)     // return false - PASS
f(1)        // return false - PASS
f(0)        // return false - PASS
f(false)    // return false - PASS


func expect(closure: () -> Bool) -> Bool {

    return closure()
}

var newOpt: Any? = 1

if let newOpt = newOpt {
    false
} else {
    true
}

expect {
    if newOpt {
        return false
    }
    return true
}

newOpt ? false : true

func decode(value: Any?) -> String {

    switch value {
    case .None:
        return "None"
    case .Some(let value):
        return "Some"

    }
    return "None"
}

var optional: Any?

decode(optional)
decode(nil)
decode(1)
decode(true)

if optional {
    println("should not get here")
}

if let value = optional {
    println("nor here")
}
