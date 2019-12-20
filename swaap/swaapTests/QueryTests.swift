//
//  swaapTests.swift
//  swaapTests
//
//  Created by Marlon Raskin on 11/11/19.
//  Copyright © 2019 swaap. All rights reserved.
//
//swiftlint:disable force_try

import XCTest
@testable import swaap

class QueryTests: XCTestCase {

	func testQueryGeneration() {
		let query = SwaapGQLQueries.fetchUserProfileQuery

		print(query)
		XCTAssert(!query.contains("\n"))
	}
}
