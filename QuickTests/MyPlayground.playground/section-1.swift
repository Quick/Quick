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



