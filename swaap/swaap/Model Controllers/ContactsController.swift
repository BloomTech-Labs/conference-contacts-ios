//
//  ContactsController.swift
//  swaap
//
//  Created by Michael Redig on 11/12/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation
import NetworkHandler

class ContactsController {
	let profileController: ProfileController
	let authManager: AuthManager

	let networkHandler: NetworkHandler = {
		let networkHandler = NetworkHandler()
		networkHandler.graphQLErrorSupport = true
		return networkHandler
	}()

	var graphqlURL: URL {
		profileController.graphqlURL
	}

	init(profileController: ProfileController) {
		self.profileController = profileController
		self.authManager = profileController.authManager
	}

	// MARK: - Fetching
	func fetchUser(with id: String, completion: @escaping (Result<UserProfile, NetworkError>) -> Void) {
		guard var request = authManager.networkAuthRequestCommon(for: graphqlURL) else {
			completion(.failure(NetworkError.unspecifiedError(reason: "Request was not attainable.")))
			return
		}

		let query = """
				query ($id: ID!) { user(id: $id) { id authId name picture birthdate location industry \
				jobtitle tagline bio profile { id value type privacy preferredContact } qrcodes { id \
				label scans } } }
				"""
		let variables = ["id": id]

		let graphObject = GQuery(query: query, variables: variables)

		do {
			request.httpBody = try graphObject.jsonData()
		} catch {
			NSLog("Failed encoding graph object: \(error)")
			completion(.failure(.dataCodingError(specifically: error, sourceData: nil)))
			return
		}

		request.expectedResponseCodes = [200]
		networkHandler.transferMahCodableDatas(with: request) { (result: Result<UserProfileContainer, NetworkError>) in
			do {
				let container = try result.get()
				completion(.success(container.userProfile))
			} catch {
				NSLog("Error fetching requested user: \(error)")
				completion(.failure(error as? NetworkError ?? NetworkError.otherError(error: error)))
			}
		}
	}

	func fetchQRCode(with id: String, completion: @escaping (Result<ProfileQRCode, NetworkError>) -> Void) {
		guard var request = authManager.networkAuthRequestCommon(for: graphqlURL) else {
			completion(.failure(NetworkError.unspecifiedError(reason: "Request was not attainable.")))
			return
		}

		let query = """
				query ($id: ID!) {
					qrcode(id: $id) {
						id
						label
						scans
						user {
							id authId name picture birthdate location industry jobtitle tagline bio profile { id value type privacy preferredContact }
						}
					}
				}
				"""
		let variables = ["id": id]

		let graphObject = GQuery(query: query, variables: variables)

		do {
			request.httpBody = try graphObject.jsonData()
		} catch {
			NSLog("Failed encoding graph object: \(error)")
			completion(.failure(.dataCodingError(specifically: error, sourceData: nil)))
			return
		}

		request.expectedResponseCodes = [200]
		networkHandler.transferMahCodableDatas(with: request) { (result: Result<ProfileQRCodeContainer, NetworkError>) in
			do {
				let container = try result.get()
				completion(.success(container.qrCode))
			} catch {
				NSLog("Error fetching requested user: \(error)")
				completion(.failure(error as? NetworkError ?? NetworkError.otherError(error: error)))
			}
		}
	}

	func requestConnection(toUserID userID: String, completion: @escaping (Result<GQLMutationResponse, NetworkError>) -> Void) {
		guard var request = authManager.networkAuthRequestCommon(for: graphqlURL) else {
			completion(.failure(NetworkError.unspecifiedError(reason: "Request was not attainable.")))
			return
		}

		let query = "mutation ($id:ID!) { createConnection(userID: $id) { success code message } }"
		let variables = ["id": userID]

		let graphObject = GQuery(query: query, variables: variables)

		do {
			request.httpBody = try graphObject.jsonData()
		} catch {
			NSLog("Failed encoding graph object: \(error)")
			completion(.failure(.dataCodingError(specifically: error, sourceData: nil)))
			return
		}

		request.expectedResponseCodes = [200]
		networkHandler.transferMahCodableDatas(with: request) { (result: Result<GQLMutationResponseContainer, NetworkError>) in
			do {
				let container = try result.get()
				completion(.success(container.response))
			} catch {
				NSLog("Error requesting connection to user: \(error)")
				completion(.failure(error as? NetworkError ?? NetworkError.otherError(error: error)))
			}
		}
	}

	func fetchAllContacts(completion: @escaping (Result<ContactContainer, NetworkError>) -> Void) {
		guard var request = authManager.networkAuthRequestCommon(for: graphqlURL) else {
			completion(.failure(NetworkError.unspecifiedError(reason: "Request was not attainable.")))
			return
		}

		let query = """
				{ user { sentConnections { id receiver { id authId name picture birthdate location industry jobtitle\
				 tagline bio profile { id value type privacy preferredContact } } status } receivedConnections \
				{ id sender { id authId name picture birthdate location industry jobtitle tagline bio profile { \
				id value type privacy preferredContact } } status } } }
				"""
		let graphObject = GQuery(query: query)
		do {
			request.httpBody = try graphObject.jsonData()
		} catch {
			NSLog("Failed encoding graph object: \(error)")
			completion(.failure(.dataCodingError(specifically: error, sourceData: nil)))
			return
		}

		request.expectedResponseCodes = [200]
		networkHandler.transferMahCodableDatas(with: request, completion: completion)
	}
}
