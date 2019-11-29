//
//  swaapTests.swift
//  swaapTests
//
//  Created by Marlon Raskin on 11/11/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import XCTest
@testable import swaap

class SwaapTests: XCTestCase {

//	override func setUp() {
//		// Put setup code here. This method is called before the invocation of each test method in the class.
//	}
//
//	override func tearDown() {
//		// Put teardown code here. This method is called after the invocation of each test method in the class.
//	}

	func testRangeNormalizing() {
		let rangeA = 0...10
		let rangeB = -10...10
		let rangeC = -5.0...11.5

		XCTAssertEqual(0, rangeA.normalizedIndex(0))
		XCTAssertEqual(1, rangeA.normalizedIndex(10))
		XCTAssertEqual(0.2, rangeA.normalizedIndex(2))
		XCTAssertEqual(-1, rangeA.normalizedIndex(-10))

		XCTAssertEqual(0, rangeB.normalizedIndex(-10))
		XCTAssertEqual(1, rangeB.normalizedIndex(10))
		XCTAssertEqual(0.5, rangeB.normalizedIndex(0))
		XCTAssertEqual(1.5, rangeB.normalizedIndex(20))

		XCTAssertEqual(0, rangeC.normalizedIndex(-5))
		XCTAssertEqual(1, rangeC.normalizedIndex(11.5))
		XCTAssertEqual(0.5, rangeC.normalizedIndex(3.25))
		XCTAssertEqual(1.5, rangeC.normalizedIndex(19.75))

	}
}
