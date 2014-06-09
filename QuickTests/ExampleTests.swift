//
//  ExampleTests.swift
//  Quick
//
//  Created by Adam Sharp on 9/06/2014.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import XCTest
import Quick

class ExampleTests: XCTestCase {

    var group: ExampleGroup! = ExampleGroup("group description")
    var subgroup: ExampleGroup! = ExampleGroup("subgroup description")
    var example: Example! = Example("example description", {})

    override func tearDown() {
        group = nil
        subgroup = nil
        example = nil
    }

    func testName() {
        group.appendExample(example)
        XCTAssertEqual(example.name,
            "group description, example description",
            "expected example name to include group description")
    }

    func testNameInNestedExampleGroup() {
        group.appendExampleGroup(subgroup)
        subgroup.appendExample(example)
        XCTAssertEqual(example.name,
            "group description, subgroup description, example description",
            "expected example name to include group and subgroup descriptions")
    }

}
