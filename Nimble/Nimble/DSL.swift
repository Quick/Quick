//
//  DSL.swift
//  Nimble
//
//  Created by Brian Ivan Gesiak on 6/6/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

@objc class DSL {
    class func expect(actual: NSObject?, file: String = __FILE__, line: Int = __LINE__) -> Actual {
        return Actual(actual, callsite: Callsite(file: file, line: line))
    }

    @objc(expectBlock:file:line:) class func expect(closure: () -> (NSObject?), file: String = __FILE__, line: Int = __LINE__) -> ActualClosure {
        return ActualClosure(closure, callsite: Callsite(file: file, line: line))
    }
}

func expect(actual: NSObject?, file: String = __FILE__, line: Int = __LINE__) -> Actual {
    return DSL.expect(actual, file: file, line: line)
}

func expect(closure: () -> (NSObject?), file: String = __FILE__, line: Int = __LINE__) -> ActualClosure {
    return DSL.expect(closure, file: file, line: line)
}
