//
//  ProfileController.swift
//  swaap
//
//  Created by Michael Redig on 12/5/19.
//  Copyright © 2019 swaap. All rights reserved.
//
//swiftlint:disable function_body_length

import Foundation
import NetworkHandler
import Cloudinary
import CoreLocation

protocol ProfileAccessor: AnyObject {
	var profileController: ProfileController? { get set }
}

class ProfileController {
	let authManager: AuthManager
	let locationManager = LocationHandler()

	/// Automatically sends `userProfileChanged` (all events), `userProfilePopulated` (when nil -> value),
	/// `userProfileDepopulated` (value -> nil), or `userProfileModified` (value -> value) notifications when modified
	var userProfile: UserProfile? {
		didSet {
			checkUserProfileChanged(oldValue: oldValue, newValue: userProfile)
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

	private var depopCredentialObserver: NSObjectProtocol?
	private var restoredCredentialObserver: NSObjectProtocol?

	// MARK: - Lifecycle
	init(authManager: AuthManager) {
		self.authManager = authManager
		depopCredentialObserver = NotificationCenter.default.addObserver(forName: .swaapCredentialsDepopulated, object: nil, queue: nil, using: { _ in
			self.userProfile = nil
		})
		// theoretically, this should run before the credentials are restored, (but it doesnt) and the following code should not be populated (but it is), so I'm not sure how to proceed
//		restoredCredentialObserver = NotificationCenter.default.addObserver(forName: .swaapCredentialsRestored, object: nil, queue: nil, using: { _ in
//			self.fetchProfileFromServer { (result: Result<UserProfile, NetworkError>) in
//				do {
//					let user = try result.get()
//					print(user)
//				} catch {
//					NSLog("Error getting user: \(error)")
//				}
//			}
//		})
		if authManager.credentials != nil {
			self.fetchProfileFromServer { (result: Result<UserProfile, NetworkError>) in
				switch result {
				case .success:
					break
				case .failure(let error):
					NSLog("Error getting user: \(error)")
				}
			}
		}

		locationManager.delegate = self
		locationManager.requestAuth()
		locationManager.singleLocationRequest()
	}

	// MARK: - Networking
	// MARK: - Profile
	func createProfileOnServer(session: NetworkLoader = URLSession.shared, completion: ((Result<GQLMutationResponse, NetworkError>) -> Void)? = nil) {
		guard let idClaims = authManager.idClaims else { return }
		guard let cRequest = networkAuthRequestCommon() else {
			completion?(.failure(NetworkError.unspecifiedError(reason: "Request was not attainable.")))
			return
		}
		var request = cRequest

		let mutation = SwaapGQLQueries.userProfileCreateMutation
		let createUser = CreateUser(name: idClaims.name, picture: idClaims.picture, email: idClaims.email)
		do {
			let userDict = try createUser.toDict()
			let variables = ["user": userDict]
			let graphObject = GQMutation(query: mutation, variables: variables)

			request.httpBody = try graphObject.jsonData()
		} catch {
			NSLog("Failed encoding graph object: \(error)")
			completion?(.failure(.dataCodingError(specifically: error, sourceData: nil)))
			return
		}

		request.expectedResponseCodes = 200
		networkHandler.transferMahCodableDatas(with: request, session: session) { (result: Result<GQLMutationResponseContainer, NetworkError>) in
			do {
				let responseContainer = try result.get()
				let response = responseContainer.response
				completion?(.success(response))
			} catch let error as NetworkError {
				NSLog("Error creating server profile: \(error)")
				completion?(.failure(error))
			} catch {
				NSLog("Error creating server profile: \(error)")
				completion?(.failure(NetworkError.otherError(error: error)))
			}
		}
	}

	func fetchProfileFromServer(session: NetworkLoader = URLSession.shared, completion: @escaping (Result<UserProfile, NetworkError>) -> Void) {
		guard var request = networkAuthRequestCommon() else {
			completion(.failure(NetworkError.unspecifiedError(reason: "Request was not attainable.")))
			return
		}
		// while networking, load from disk if same user
		loadCachedProfile()

		let query = SwaapGQLQueries.userProfileFetchQuery
		let graphObject = GQuery(query: query)

		do {
			request.httpBody = try graphObject.jsonData()
		} catch {
			NSLog("Failed encoding graph object: \(error)")
			completion(.failure(.dataCodingError(specifically: error, sourceData: nil)))
			return
		}

		request.expectedResponseCodes = [200]

		networkHandler.transferMahCodableDatas(with: request, session: session) { (result: Result<UserProfileContainer, NetworkError>) in
			do {
				let userProfileContainer = try result.get()
				let userProfile = userProfileContainer.userProfile
				self.userProfile = userProfile
				completion(.success(userProfile))
			} catch NetworkError.dataCodingError(let error, let dataSource) {
				NSLog("Error decoding current user: \(error)")
				print(String(data: dataSource ?? Data(), encoding: .utf8) ?? "")
			} catch NetworkError.graphQLError(let graphQLError) {
				// only attempt creation if error code relating to user not existing ocurrs
				// I don't know if its guaranteed to be consistent that no user existing will always have an error like this
				// but it's the best we got right now
				if graphQLError.message.contains("User does not exist") && graphQLError.extensions.code == "UNAUTHENTICATED" {
					self.createProfileOnServer { result in
						do {
							let response = try result.get()
							if response.success {
								self.fetchProfileFromServer(completion: completion)
							} else {
								completion(.failure(NetworkError.graphQLError(error: graphQLError)))
								NSLog("Error fetching current user \(#line) \(#file): \(graphQLError)")
							}
						} catch let error as NetworkError {
							completion(.failure(error))
						} catch {
							completion(.failure(NetworkError.otherError(error: error)))
						}
					}
				} else {
					NSLog("Error fetching current user \(#line) \(#file): \(graphQLError)")
				}
			} catch {
				// attempt user creation if fetching fails
				NSLog("Error fetching current user \(#line) \(#file): \(error)")
				completion(.failure(error as? NetworkError ?? NetworkError.otherError(error: error)))
			}
		}
	}

	func updateProfile(_ userProfile: UserProfile,
					   session: NetworkLoader = URLSession.shared,
					   completion: @escaping (Result<GQLMutationResponse, NetworkError>) -> Void) {
		guard var request = networkAuthRequestCommon() else {
			completion(.failure(NetworkError.unspecifiedError(reason: "Request was not attainable.")))
			return
		}

		let mutation = SwaapGQLQueries.userProfileUpdateMutation
		let userInfo = UpdateUser(userProfile: userProfile)

		do {
			let updateDict = try userInfo.toDict()
			let variables = ["data": updateDict]
			let graphObject = GQMutation(query: mutation, variables: variables)
			
			request.httpBody = try graphObject.jsonData()
		} catch {
			NSLog("Failed encoding user update: \(error)")
			completion(.failure(.dataCodingError(specifically: error, sourceData: nil)))
			return
		}

		request.expectedResponseCodes = 200
		networkHandler.transferMahCodableDatas(with: request, session: session) { (result: Result<GQLMutationResponseContainer, NetworkError>) in
			do {
				let responseContainer = try result.get()
				let response = responseContainer.response
				completion(.success(response))
			} catch {
				NSLog("Error updating server profile \(#line) \(#file): \(error)")
				completion(.failure(error as? NetworkError ?? NetworkError.otherError(error: error)))
			}
		}
	}

	func createQRCode(labeled label: String,
					  session: NetworkLoader = URLSession.shared,
					  completion: @escaping (Result<GQLMutationResponse, NetworkError>) -> Void) {
		guard var request = networkAuthRequestCommon() else {
			completion(.failure(NetworkError.unspecifiedError(reason: "Request was not attainable.")))
			return
		}

		let mutation = SwaapGQLQueries.userProfileCreateQRCodeMutation
		let variables = ["label": label]

		do {
			let graphObject = GQMutation(query: mutation, variables: variables)

			request.httpBody = try graphObject.jsonData()
		} catch {
			NSLog("Failed encoding qr code request: \(error)")
			completion(.failure(.dataCodingError(specifically: error, sourceData: nil)))
			return
		}

		request.expectedResponseCodes = 200
		networkHandler.transferMahCodableDatas(with: request, session: session) { (result: Result<GQLMutationResponseContainer, NetworkError>) in
			do {
				let responseContainer = try result.get()
				let response = responseContainer.response
				completion(.success(response))
			} catch {
				NSLog("Error creating qr code on server \(#line) \(#file): \(error)")
				completion(.failure(error as? NetworkError ?? NetworkError.otherError(error: error)))
			}
		}
	}

	// MARK: - ContactMethods

	func createContactMethods(_ contactMethods: [ProfileContactMethod],
							  session: NetworkLoader = URLSession.shared,
							  completion: @escaping (Result<GQLMutationResponse, NetworkError>) -> Void) {
		guard var request = networkAuthRequestCommon() else {
			completion(.failure(NetworkError.unspecifiedError(reason: "Request was not attainable.")))
			return
		}

		let mutation = SwaapGQLQueries.userProfileContactMethodsCreateMutation

		do {
			let contactMethodDicts = try contactMethods.map { try MutateProfileContactMethod(contactMethod: $0).toDict() }
			let variables = ["data": contactMethodDicts]

			let graphObject = GQMutation(query: mutation, variables: variables)

			request.httpBody = try graphObject.jsonData()
		} catch {
			NSLog("Failed encoding contact methods update: \(error)")
			completion(.failure(.dataCodingError(specifically: error, sourceData: nil)))
			return
		}

		request.expectedResponseCodes = 200
		networkHandler.transferMahCodableDatas(with: request, session: session) { (result: Result<GQLMutationResponseContainer, NetworkError>) in
			do {
				let responseContainer = try result.get()
				let response = responseContainer.response
				completion(.success(response))
			} catch let error as NetworkError {
				NSLog("Error creating profile contact method: \(error)")
				completion(.failure(error))
			} catch {
				NSLog("Error creating profile contact method: \(error)")
				completion(.failure(NetworkError.otherError(error: error)))
			}
		}
	}

	func updateProfileContactMethods(_ contactMethods: [ProfileContactMethod],
									 session: NetworkLoader = URLSession.shared,
									 completion: @escaping (Result<GQLMutationResponse, NetworkError>) -> Void) {
		guard var request = networkAuthRequestCommon() else {
			completion(.failure(NetworkError.unspecifiedError(reason: "Request was not attainable.")))
			return
		}
		guard (contactMethods.allSatisfy { $0.id != nil }) else {
			completion(.failure(NetworkError.unspecifiedError(reason: "A contact method without an id attempted update in: \(contactMethods)")))
			return
		}

		let mutation = SwaapGQLQueries.userProfileContactMethodsUpdateMutation
		do {
			let contactMethodsDicts = try contactMethods.map { try MutateProfileContactMethod(contactMethod: $0).toDict() }
			let variables = ["data": contactMethodsDicts]

			let graphObject = GQMutation(query: mutation, variables: variables)

			request.httpBody = try graphObject.jsonData()
		} catch {
			NSLog("Failed encoding contact methods update: \(error)")
			completion(.failure(.dataCodingError(specifically: error, sourceData: nil)))
			return
		}

		request.expectedResponseCodes = 200
		networkHandler.transferMahCodableDatas(with: request, session: session) { (result: Result<GQLMutationResponseContainer, NetworkError>) in
			do {
				let responseContainer = try result.get()
				let response = responseContainer.response
				completion(.success(response))
			} catch {
				NSLog("Error updating profile contact method: \(error)")
				completion(.failure(error as? NetworkError ?? NetworkError.otherError(error: error)))
			}
		}
	}

	func deleteProfileContactMethods(_ contactMethods: [ProfileContactMethod],
									 session: NetworkLoader = URLSession.shared,
									 completion: @escaping (Result<GQLMutationResponse, NetworkError>) -> Void) {
		guard var request = networkAuthRequestCommon() else {
			completion(.failure(NetworkError.unspecifiedError(reason: "Request was not attainable.")))
			return
		}

		let ids = contactMethods.compactMap { $0.id }
		guard !ids.isEmpty else {
			completion(.failure(.unspecifiedError(reason: "No viable contact methods provided for deletion: \(contactMethods)")))
			return
		}
		let mutation = SwaapGQLQueries.userProfileContactMethodsDeleteMutation
		do {
			let query = GQuery(query: mutation, variables: ["ids": ids])

			request.httpBody = try query.jsonData()
		} catch {
			NSLog("Failed encoding user update: \(error)")
			completion(.failure(.dataCodingError(specifically: error, sourceData: nil)))
			return
		}

		request.expectedResponseCodes = 200
		networkHandler.transferMahCodableDatas(with: request, session: session) { (result: Result<GQLMutationResponseContainer, NetworkError>) in
			do {
				let responseContainer = try result.get()
				let response = responseContainer.response
				completion(.success(response))
			} catch let error as NetworkError {
				NSLog("Error deleting profile contact method: \(error)")
				completion(.failure(error))
			} catch {
				NSLog("Error deleting profile contact method: \(error)")
				completion(.failure(NetworkError.otherError(error: error)))
			}
		}
	}

	private func networkAuthRequestCommon() -> NetworkRequest? {
		return authManager.networkAuthRequestCommon(for: graphqlURL)
	}

	@discardableResult func fetchImage(url: URL, session: NetworkLoader = URLSession.shared, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
		return networkHandler.transferMahDatas(with: url.request, usingCache: true, session: session, completion: completion)
	}

	/// By default, only updates if photo is nil. `force` will force it to download, even if there's already data.
	/// - Parameter force: Bool determining if the update is forced or contextual.
	func updateUserImage(_ force: Bool = false) {
		guard let userProfile = userProfile, (force || userProfile.photoData == nil) else { return }
		fetchImage(url: userProfile.pictureURL) { (result: Result<Data, NetworkError>) in
			do {
				self.userProfile?.photoData = try result.get()
			} catch {
				NSLog("Error loading user profile image: \(error)")
			}
		}
	}

	private func checkUserQRCode() {
		guard let userProfile = userProfile, userProfile.qrCodes.isEmpty else { return }

		self.userProfile?.qrCodes.append(ProfileQRCode(id: "dummy", label: "dummy", scans: 0))

		createQRCode(labeled: "Default") { [weak self] (result: Result<GQLMutationResponse, NetworkError>) in
			switch result {
			case .success:
				self?.fetchProfileFromServer(completion: { _ in })
			case .failure(let error):
				NSLog("Error populating QR Code: \(error)")
			}
		}
	}


	// MARK: - Image
	private let cloudinaryConfig = CLDConfiguration(cloudName: "swaap", secure: true)
	private lazy var cloudinary = CLDCloudinary(configuration: cloudinaryConfig)

	func uploadImageData(_ data: Data, completion: @escaping (Result<URL, NetworkError>) -> Void) {
		let request = cloudinary.createUploader().upload(data: data, uploadPreset: "zkbfj0cu") { result, error in
			if let error = error {
				NSLog("Error uploading image: \(error)")
				completion(.failure(.otherError(error: error)))
				return
			}
			guard let urlStr = result?.secureUrl ?? result?.url, let url = URL(string: urlStr) else {
				completion(.failure(.unspecifiedError(reason: "No url provided in result!: \(result.debugDescription)")))
				return
			}
			completion(.success(url))
		}
		request.resume()
	}

	// MARK: - Local Storage
	private let fm = FileManager.default
	private let profileCacheFilename = "profile.plist"
	private var profileCacheURL: URL {
		guard let cacheFolder = fm.urls(for: .cachesDirectory, in: .userDomainMask).first else { preconditionFailure("Something catastophically wrong occurred...") }
		return cacheFolder.appendingPathComponent(profileCacheFilename)
	}

	private func loadCachedProfile() {
		// note - doesn't trigger populate notification on startup because it happens before the observer is initialized
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
		guard let profile = userProfile else {
			return
		}

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

	private func deleteProfileCache() {
		do {
			try fm.removeItem(at: profileCacheURL)
		} catch {
			NSLog("Error deleting profile cache: \(error)")
		}
	}
}

extension ProfileController: LocationHandlerDelegate {
	func locationRequester(_ locationRequester: LocationHandler, didUpdateLocation location: CLLocation) {
		print(location)
	}
}

// MARK: - Notifications
extension ProfileController {
	private func checkUserProfileChanged(oldValue: UserProfile?, newValue: UserProfile?) {
		guard oldValue != newValue else { return }
		let nc = NotificationCenter.default
		if oldValue == nil {
			nc.post(name: .userProfilePopulated, object: nil)
			nc.post(name: .userProfileChanged, object: nil)
		} else if newValue == nil {
			nc.post(name: .userProfileDepopulated, object: nil)
			nc.post(name: .userProfileChanged, object: nil)
		} else {
			nc.post(name: .userProfileModified, object: nil)
			nc.post(name: .userProfileChanged, object: nil)
		}
		updateUserImage()
		checkUserQRCode()
		saveProfileToCache()
	}
}

extension NSNotification.Name {
	static let userProfileModified = NSNotification.Name("com.swaap.userProfileChanged")
	static let userProfileChanged = NSNotification.Name("com.swaap.userProfileChanged")
	static let userProfilePopulated = NSNotification.Name("com.swaap.userProfilePopulated")
	static let userProfileDepopulated = NSNotification.Name("com.swaap.userProfileDepopulated")
}
