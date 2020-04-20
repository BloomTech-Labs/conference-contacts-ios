//
//  UserDefaultsMockTests.swift
//  swaapTests
//
//  Created by Chad Rutherford on 4/20/20.
//  Copyright © 2020 swaap. All rights reserved.
//

import XCTest
@testable import swaap

class UserDefaultsTests: XCTestCase {
	
	func testUserDefaultsMock() {
		let objectKey = "InitialLaunch"
		let userDefaults = UserDefaultsMock() as UserDefaultsProtocol
		userDefaults.setObject(true, forKey: objectKey)
		XCTAssertNotNil(userDefaults.objectForKey(objectKey))
		if let key = userDefaults.objectForKey(objectKey) as? Bool {
			XCTAssertTrue(key)
		}
	}
}
