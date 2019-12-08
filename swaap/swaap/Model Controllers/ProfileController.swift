//
//  ProfileController.swift
//  swaap
//
//  Created by Michael Redig on 12/5/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation
import NetworkHandler

protocol ProfileAccessor: AnyObject {
	var profileController: ProfileController? { get set }
}

class ProfileController {
	let authManager: AuthManager

	private var _userProfile: UserProfile?
	/// Automatically sends `userProfileChanged`, `userProfilePopulated`, or `userProfileDepopulated` notifications when modified
	var userProfile: UserProfile? {
		get { _userProfile }
		set {
			checkUserProfileChanged(oldValue: _userProfile, newValue: newValue)
			_userProfile = newValue
		}
	}

	let baseURL = URL(string: "https://lambda-labs-swaap-staging.herokuapp.com/")!
	var graphqlURL: URL {
		baseURL.appendingPathComponent("graphql")
	}
	let networkHandler: NetworkHandler = {
		let networkHandler = NetworkHandler()
		networkHandler.graphQLErrorSupport = true
		return networkHandler
	}()

	// MARK: - Lifecycle
	init(authManager: AuthManager) {
		self.authManager = authManager
	}

	// MARK: - Networking
	func createProfileOnServer(completion: ((Bool) -> Void)? = nil) {
		guard let (idClaims, cRequest) = networkCommon() else {
			completion?(false)
			return
		}
		var request = cRequest

		let mutation = "mutation CreateUser($user: CreateUserInput!) { createUser(data: $user) { success code message } }"
		let userInfo = ["user": CreateUser(name: idClaims.name, picture: idClaims.picture, email: idClaims.email)]

		let graphObject = GQMutation(query: mutation, variables: userInfo)

		do {
			request.httpBody = try JSONEncoder().encode(graphObject)
		} catch {
			NSLog("Failed encoding graph object: \(error)")
			completion?(false)
			return
		}

		request.expectedResponseCodes = 200 // getting incorrect code back from server - should be 201
		networkHandler.transferMahCodableDatas(with: request) { (result: Result<[String: [String: UserMutationResponse]], NetworkError>) in
			do {
				let responseDict = try result.get()
				guard let userMutationResponse = responseDict["data"]?["createUser"] else {
					completion?(false)
					return
				}
				completion?(userMutationResponse.success)
			} catch NetworkError.httpNon200StatusCode(let code, let data) {
				NSLog("Error creating server profile with code: \(code): \(String(data: data!, encoding: .utf8)!)")
				completion?(false)
			} catch {
				NSLog("Error creating server profile: \(error)")
				completion?(false)
			}
		}
	}

	func fetchProfileFromServer(completion: @escaping (Result<UserProfile, NetworkError>) -> Void) {
		guard var (_, request) = networkCommon() else {
			completion(.failure(NetworkError.unspecifiedError(reason: "Either claims or request were not attainable.")))
			return
		}

		let query = "{ user { id authId name picture birthdate gender industry jobtitle bio profile { id value type privacy preferredContact } } }"
		let graphObject = GQuery(query: query)

		do {
			request.httpBody = try JSONEncoder().encode(graphObject)
		} catch {
			NSLog("Failed encoding graph object: \(error)")
			completion(.failure(.dataCodingError(specifically: error, sourceData: nil)))
			return
		}

		request.expectedResponseCodes = [200]

		networkHandler.transferMahCodableDatas(with: request) { (result: Result<UserProfileContainer, NetworkError>) in
			do {
				let userProfileContainer = try result.get()
				let userProfile = userProfileContainer.userProfile
				self.userProfile = userProfile
				completion(.success(userProfile))
			} catch NetworkError.dataCodingError(let error, let dataSource) {
				print("")
				NSLog("Error decoding current user: \(error)")
				print("")
				print(String(data: dataSource ?? Data(), encoding: .utf8) ?? "")
				print("")
			} catch {
				// attempt user creation if fetching fails
				// FIXME: only attempt creation if error code relating to user not existing ocurrs
				self.createProfileOnServer { success in
					if success {
						self.fetchProfileFromServer(completion: completion)
					} else {
						completion(.failure(.otherError(error: error)))
						print("")
						NSLog("Error fetching current user: \(error)")
					}
				}
			}
		}
	}

	private func networkCommon() -> (Auth0IDClaims, NetworkRequest)? {
		guard let idClaims = authManager.idClaims, let accessToken = authManager.credentials?.accessToken else { return nil }
		var request = graphqlURL.request
		request.addValue(.contentType(type: .json), forHTTPHeaderField: .commonKey(key: .contentType))
		request.addValue(.other(value: accessToken), forHTTPHeaderField: .commonKey(key: .authorization))
		request.httpMethod = .post
		return (idClaims, request)
	}

	// MARK: - Local Storage
	private let fm = FileManager.default
	private let profileCacheFilename = "profile.plist"
	private var profileCacheURL: URL {
		guard let cacheFolder = fm.urls(for: .cachesDirectory, in: .userDomainMask).first else { preconditionFailure("Something catastophically wrong occurred...") }
		return cacheFolder.appendingPathComponent(profileCacheFilename)
	}

	private func loadCachedProfile() {
		guard fm.fileExists(atPath: profileCacheURL.path), let claims = authManager.idClaims else { return }
		let data: Data
		do {
			data = try Data(contentsOf: profileCacheURL)
		} catch {
			NSLog("Error loading cached profile data: \(error)")
			return
		}

		do {
			let userProfile = try PropertyListDecoder().decode(UserProfile.self, from: data)
			if userProfile.authID == claims.authID {
				self.userProfile = userProfile
			}
		} catch {
			NSLog("Error decoding cached profile data: \(error)")
		}
	}

	private func saveProfileToCache() {
		guard let profile = userProfile else { return }

		let data: Data
		do {
			data = try PropertyListEncoder().encode(profile)
		} catch {
			NSLog("Error encoding profile cache: \(error)")
			return
		}

		do {
			try data.write(to: profileCacheURL)
		} catch {
			NSLog("Error saving profile cache: \(error)")
		}
	}
}

// MARK: - Notifications
extension ProfileController {
	private func checkUserProfileChanged(oldValue: UserProfile?, newValue: UserProfile?) {
		guard oldValue != newValue else { return }
		let nc = NotificationCenter.default
		if oldValue == nil {
			nc.post(name: .userProfilePopulated, object: nil)
		} else if newValue == nil {
			nc.post(name: .userProfileDepopulated, object: nil)
		} else {
			nc.post(name: .userProfileChanged, object: nil)
		}
		saveProfileToCache()
	}
}

extension NSNotification.Name {
	static let userProfileChanged = NSNotification.Name("com.swaap.userProfileChanged")
	static let userProfilePopulated = NSNotification.Name("com.swaap.userProfilePopulated")
	static let userProfileDepopulated = NSNotification.Name("com.swaap.userProfileDepopulated")
}
