//
//  ResultBuilderTests.swift
//  Quick
//
//  Created by Alex on 2022-04-25.
//  Copyright © 2022 Brian Ivan Gesiak. All rights reserved.
//

import Nimble
@testable import Quick
import XCTest


private enum BeforeEachType: String, CustomStringConvertible {
	case outerOne
	case outerTwo
	case innerOne
	case innerTwo
	case innerThree
	case noExamples

	var description: String { self.rawValue }
}

private var beforeEachOrder = [BeforeEachType]()

class FunctionalTests_ResultBuilderBeforeEachSpec: ResultBuilderQuickSpec {
	override class func spec() -> Spec {
		Spec {
			describe_builder("beforeEach ordering") {
				print("hook evaluated")
				beforeEachOrder.append(.outerOne)
				beforeEachOrder.append(.outerTwo)

				it_builder("executes the outer beforeEach closures once [1]") {
					print("foo 1")
				}
				it_builder("executes the outer beforeEach closures a second time [2]") {
					print("foo 2")
				}
				context_builder("when there are nested beforeEach") {
					beforeEachOrder.append(.innerOne)
					beforeEachOrder.append(.innerTwo)
					beforeEachOrder.append(.innerThree)

					it_builder("executes the outer and inner beforeEach closures [3]") {
						print("foo 3")
					}
				}

				context_builder("when there are nested beforeEach without examples") {
					beforeEach { beforeEachOrder.append(.noExamples) }
				}
			}
		}
	}
}

final class ResultBuilderBeforeEachTests: XCTestCase, XCTestCaseProvider {
	static var allTests: [(String, (ResultBuilderBeforeEachTests) -> () throws -> Void)] {
		return [
			("testBeforeEachIsExecutedInTheCorrectOrder", testBeforeEachIsExecutedInTheCorrectOrder),
		]
	}

	func testBeforeEachIsExecutedInTheCorrectOrder() {
		beforeEachOrder = []

		qck_runSpec(FunctionalTests_ResultBuilderBeforeEachSpec.self)
		let expectedOrder: [BeforeEachType] = [
			// [1] The outer beforeEach closures are executed from top to bottom.
			.outerOne, .outerTwo,
			// [2] The outer beforeEach closures are executed from top to bottom.
			.outerOne, .outerTwo,
			// [3] The outer beforeEach closures are executed from top to bottom,
			//     then the inner beforeEach closures are executed from top to bottom.
			.outerOne, .outerTwo, .innerOne, .innerTwo, .innerThree,
		]
		XCTAssertEqual(beforeEachOrder, expectedOrder)
	}
}
