//
//  ExampleTests.swift
//  Quick
//
//  Created by Adam Sharp on 16/06/2014.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import XCTest
import Quick

class ExampleTests: XCTestCase {

    func testCallsite() {
        let callsite = Callsite(file: "file", line: 10)
        let example = Example("example", callsite, {})
        XCTAssertEqual(example._file, callsite.file, "expected _file property to delegate to the callsite")
        XCTAssertEqual(example._line, callsite.line, "expected _line property to delegate to the callsite")
    }

}
