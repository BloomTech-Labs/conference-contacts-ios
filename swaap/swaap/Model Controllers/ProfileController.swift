//
//  ProfileController.swift
//  swaap
//
//  Created by Michael Redig on 12/5/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation
import NetworkHandler

class ProfileController {
	let authManager: AuthManager

	var userProfile: UserProfile?

	let baseURL = URL(string: "https://lambda-labs-swaap-staging.herokuapp.com/")!
	var graphqlURL: URL {
		baseURL.appendingPathComponent("graphql")
	}
	let networkHandler = NetworkHandler()

	init(authManager: AuthManager) {
		self.authManager = authManager
	}

	func createProfileOnServer() {
		guard let idClaims = authManager.idClaims, let accessToken = authManager.credentials?.accessToken else { return }
		var request = graphqlURL.request
		request.addValue("application/json", forHTTPHeaderField: HTTPHeaderKeys.contentType.rawValue)
		request.addValue(accessToken, forHTTPHeaderField: HTTPHeaderKeys.auth.rawValue)
		request.httpMethod = HTTPMethods.post.rawValue

		let mutation = "mutation CreateUser($user: CreateUserInput!) { createUser(data: $user) { success code message } }"
		let userInfo = ["user": CreateUser(sub: idClaims.sub, name: idClaims.name, picture: idClaims.picture, email: idClaims.email)]

		let graphObject = GQuery(query: mutation, variables: userInfo)

		do {
			request.httpBody = try JSONEncoder().encode(graphObject)
		} catch {
			NSLog("Failed encoding graph object: \(error)")
		}

		networkHandler.transferMahCodableDatas(with: request) { (result: Result<[String: [String: UserMutationResponse]], NetworkError>) in
			do {
				let success = try result.get()
				print(success)
			} catch NetworkError.otherError(let error) {
				NSLog("Other error creating server profile: \(error)")
			} catch NetworkError.httpNon200StatusCode(let code, let data) {
				NSLog("Error creating server profile with code: \(code): \(String(data: data!, encoding: .utf8)!)")
			} catch {
				NSLog("Error creating server profile: \(error)")
			}
		}
	}
}
