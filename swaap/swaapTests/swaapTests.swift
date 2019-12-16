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

	func testCreateUser() {
		let authManager = AuthManager()
		let profileController = ProfileController(authManager: authManager)
	}
}
