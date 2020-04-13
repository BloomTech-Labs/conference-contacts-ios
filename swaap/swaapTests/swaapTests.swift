//
//  swaapTests.swift
//  swaapTests
//
//  Created by Marlon Raskin on 11/11/19.
//  Copyright © 2019 swaap. All rights reserved.
//
//swiftlint:disable large_tuple

import XCTest
@testable import swaap
import Auth0
import NetworkHandler
import CoreLocation

class SwaapTests: XCTestCase {

	func getCreds() -> Credentials {
		Credentials(accessToken: neAccessToken,
					tokenType: testTokenType,
					idToken: neIDToken,
					refreshToken: nil,
					expiresIn: Date(timeIntervalSinceNow: 60 * 60 * 24),
					scope: "openid profile email")
	}

	func currentLocation() -> CLLocation {
		let locationHandler = LocationHandler()
		locationHandler.requestAuth()
		locationHandler.singleLocationRequest()
		let waitForLocation = expectation(description: "wait for location")

		DispatchQueue.global().async {
			while locationHandler.lastLocation == nil {
				sleep(1)
			}
			waitForLocation.fulfill()
		}

		wait(for: [waitForLocation], timeout: 10)

		guard let location = locationHandler.lastLocation else { fatalError("Couldn't get location") }
		return location
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

	var mockingFailReturn: (Data?, Int, Error?) {
		(nil, 500, NetworkError.unspecifiedError(reason: "bad input"))
	}

//	override func setUp() {
//		// Put setup code here. This method is called before the invocation of each test method in the class.
//	}
//
//	override func tearDown() {
//		// Put teardown code here. This method is called after the invocation of each test method in the class.
//	}

	// MARK: - Profile Controller tests
	func testFetchCurrentUser() {
		let profileController = getProfileController()

		let failReturn = mockingFailReturn

		let mockingSession = NetworkMockingSession { request -> (Data?, Int, Error?) in
			guard let inputData = request.httpBody else { return failReturn }
			guard let auth = request.value(forHTTPHeaderField: "Authorization"),
				auth == neAccessToken else { return failReturn }
			let json = (try? JSONSerialization.jsonObject(with: inputData)) as? [String: Any] ?? [:]
			guard (json["query"] as? String) == SwaapGQLQueries.userProfileFetchQuery else { return failReturn }

			return (currentUserQueryResponse, 200, nil)
		}

		let waitForNetwork = expectation(description: "test")
		profileController.fetchProfileFromServer(session: mockingSession) { result in
			do {
				let user = try result.get()
				XCTAssertEqual(neUserID, user.id)
				XCTAssertEqual("Ne Num", user.name)
				XCTAssertEqual("5/6/1445", user.birthdate)
				XCTAssertEqual("Chivalry", user.industry)
				XCTAssertEqual("Not a knight of ni", user.tagline)
				XCTAssertEqual("ck4et6f11003f07464wd7lxjt", user.profileContactMethods.first?.id)
			} catch {
				XCTFail("Error testing current user fetch: \(error)")
			}
			waitForNetwork.fulfill()
		}
		waitForExpectations(timeout: 10) { error in
			if let error = error {
				XCTFail("Timed out waiting for an expectation: \(error)")
			}
		}
	}

	// MARK: - Contacts Controller tests
	func testRetrieveArbitraryUser() {
		let contactController = getContactController()

		let failReturn = mockingFailReturn
		let mockingSession = NetworkMockingSession { request -> (Data?, Int, Error?) in
			guard let inputData = request.httpBody else { return failReturn }
			guard let auth = request.value(forHTTPHeaderField: "Authorization"),
				auth == neAccessToken else { return failReturn }
			let json = (try? JSONSerialization.jsonObject(with: inputData)) as? [String: Any] ?? [:]
			guard (json["query"] as? String) == SwaapGQLQueries.connectionFetchSingleUserQuery else { return failReturn }
			guard let variables = json["variables"] as? [String: Any] else { return failReturn }

			guard (variables["id"] as? String) == geUserID else { return failReturn }
			return (arbitraryUserQueryResponse, 200, nil)
		}

		let waitForNetwork = expectation(description: "test")
		contactController.fetchUser(with: geUserID, session: mockingSession) { result in
			do {
				let user = try result.get()
				XCTAssertEqual(geUserID, user.id)
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

		let failReturn = mockingFailReturn
		let mockingSession = NetworkMockingSession { request -> (Data?, Int, Error?) in
			guard let inputData = request.httpBody else { return failReturn }
			guard let auth = request.value(forHTTPHeaderField: "Authorization"),
				auth == neAccessToken else { return failReturn }
			let json = (try? JSONSerialization.jsonObject(with: inputData)) as? [String: Any] ?? [:]
			guard (json["query"] as? String) == SwaapGQLQueries.connectionFetchQRCodeQuery else { return failReturn }
			guard let variables = json["variables"] as? [String: Any] else { return failReturn }

			guard (variables["id"] as? String) == heQRCodeID else { return failReturn }
			return (qrCodeQueryResponse, 200, nil)
		}

		let waitForNetwork = expectation(description: "test")
		contactController.fetchQRCode(with: heQRCodeID, session: mockingSession) { result in
			do {
				let qrCode = try result.get()
				XCTAssertEqual(heQRCodeID, qrCode.id)
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

	func testRequestConnection() {
		let contactController = getContactController()

		let failReturn = mockingFailReturn
		let mockingData = NetworkMockingSession { request -> (Data?, Int, Error?) in
			guard let inputData = request.httpBody else { return failReturn }
			guard let auth = request.value(forHTTPHeaderField: "Authorization"),
				auth == neAccessToken else { return failReturn }
			let json = (try? JSONSerialization.jsonObject(with: inputData)) as? [String: Any] ?? [:]
			guard (json["query"] as? String) == SwaapGQLQueries.connectionCreateMutation else { return failReturn }
			guard let variables = json["variables"] as? [String: Any] else { return failReturn }

			guard (variables["id"] as? String) == heUserID else { return failReturn }
			guard let coords = variables["coords"] as? [String: NSNumber] else { return failReturn }
			guard coords["latitude"] != nil else { return failReturn }
			guard coords["longitude"] != nil else { return failReturn }

			return (createConnectionResponse, 200, nil)
		}


		let waitForNetwork = expectation(description: "test")
		contactController.requestConnection(toUserID: heUserID, currentLocation: currentLocation(), session: mockingData) { result in
			do {
				let response = try result.get()
				XCTAssertEqual(201, response.code)
			} catch {
				XCTFail("Error testing connection request: \(error)")
			}
			waitForNetwork.fulfill()
		}
		waitForExpectations(timeout: 10) { error in
			if let error = error {
				XCTFail("Timed out waiting for an expectation: \(error)")
			}
		}
	}

	// setup mocking - i think this fails because the jwt is too old (mocking would fix)
//	func testFetchAllConnections() {
//		let contactController = getContactController()
//
//		let waitForNetwork = expectation(description: "test")
//		contactController.fetchAllContacts { result in
//			do {
//				let response = try result.get()
//				print(response)
//				// setup mocking
//				// this is where confirming good data would go (set up mocking!)
//			} catch {
//				XCTFail("Error testing all connection fetch: \(error)")
//			}
//			waitForNetwork.fulfill()
//		}
//		waitForExpectations(timeout: 10) { error in
//			if let error = error {
//				XCTFail("Timed out waiting for an expectation: \(error)")
//			}
//		}
//	}
}
