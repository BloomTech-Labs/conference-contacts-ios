//
//  swaapTests.swift
//  swaapTests
//
//  Created by Marlon Raskin on 11/11/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import XCTest
@testable import swaap
import Auth0

class SwaapTests: XCTestCase {

	func getCreds() -> Credentials {
		Credentials(accessToken: heAccessToken,
					tokenType: heTokenType,
					idToken: heIDToken,
					refreshToken: nil,
					expiresIn: Date(timeIntervalSinceNow: 60 * 60 * 24),
					scope: "openid profile email")
	}

	func getAuthManager() -> AuthManager {
		AuthManager(testCredentials: getCreds())
	}

	func getProfileController() -> ProfileController {
		ProfileController(authManager: getAuthManager())
	}

	func getContactController() -> ContactsController {
		ContactsController(profileController: getProfileController())
	}

//	override func setUp() {
//		// Put setup code here. This method is called before the invocation of each test method in the class.
//	}
//
//	override func tearDown() {
//		// Put teardown code here. This method is called after the invocation of each test method in the class.
//	}

	/// current uses live server data - requires the the constants file be updated before running
	func testRetrieveArbitraryUser() {
		let contactController = getContactController()

		let waitForNetwork = expectation(description: "test")
		contactController.fetchUser(with: "ck4axnllp01ff0702q3emyj3f") { result in
			do {
				let user = try result.get()
				XCTAssertEqual("ck4axnllp01ff0702q3emyj3f", user.id)
			} catch {
				XCTFail("Error testing single user fetch: \(error)")
			}
			waitForNetwork.fulfill()
		}
		waitForExpectations(timeout: 10) { error in
			if let error = error {
				XCTFail("Timed out waiting for an expectation: \(error)")
			}
		}
	}

	func testFetchQRCode() {
		let contactController = getContactController()

		let waitForNetwork = expectation(description: "test")
		contactController.fetchQRCode(with: "ck4axno3w01fv07020cjurtau") { result in
			do {
				let qrCode = try result.get()
				XCTAssertEqual("ck4axno3w01fv07020cjurtau", qrCode.id)
				XCTAssertEqual("Default", qrCode.label)
			} catch {
				XCTFail("Error testing qrcode fetch: \(error)")
			}
			waitForNetwork.fulfill()
		}
		waitForExpectations(timeout: 10) { error in
			if let error = error {
				XCTFail("Timed out waiting for an expectation: \(error)")
			}
		}
	}
}
