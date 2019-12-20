//
//  ContactsController.swift
//  swaap
//
//  Created by Michael Redig on 11/12/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation
import NetworkHandler
import CoreData
import CoreLocation

protocol ContactsAccessor: AnyObject {
	var contactsController: ContactsController? { get set }
}

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

		_ = NotificationCenter.default.addObserver(forName: .swaapCredentialsDepopulated, object: nil, queue: nil, using: { [weak self] _ in
			self?.clearCache()
		})

		let cacheUpdateClosure: (Notification) -> Void = { [weak self] _ in
			self?.updateContactCache()
		}
		_ = NotificationCenter.default.addObserver(forName: .swaapCredentialsPopulated, object: nil, queue: nil, using: cacheUpdateClosure)
		_ = NotificationCenter.default.addObserver(forName: .swaapCredentialsChanged, object: nil, queue: nil, using: cacheUpdateClosure)
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

		request.expectedResponseCodes = 200
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

	func requestConnection(toUserID userID: String, currentLocation: CLLocation, session: NetworkLoader = URLSession.shared, completion: @escaping (Result<GQLMutationResponse, NetworkError>) -> Void) {
		guard var request = authManager.networkAuthRequestCommon(for: graphqlURL) else {
			completion(.failure(NetworkError.unspecifiedError(reason: "Request was not attainable.")))
			return
		}
		let coords = currentLocation.coordinate

		let query = SwaapGQLQueries.createConnectionMutation
		let variables = ["id": userID,
						 "coords": ["latitude": coords.latitude,
									"longitude": coords.longitude]] as [String : Any]

		let graphObject = GQuery(query: query, variables: variables)

		do {
			request.httpBody = try graphObject.jsonData()
		} catch {
			NSLog("Failed encoding graph object: \(error)")
			completion(.failure(.dataCodingError(specifically: error, sourceData: nil)))
			return
		}

		request.expectedResponseCodes = [200]
		networkHandler.transferMahCodableDatas(with: request, session: session) { (result: Result<GQLMutationResponseContainer, NetworkError>) in
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

	func updateContactCache(completion: @escaping () -> Void = {} ) {
		fetchAllContacts { [weak self] result in
			guard let self = self else {
				completion()
				return
			}
			do {
				let container = try result.get()
				let connections = container.connections
				let context = CoreDataStack.shared.container.newBackgroundContext()
				context.performAndWait {
					var allCached = Set(self.allCachedContacts(onContext: context))

					for contact in connections {
						if let cachedConnection = self.getContactFromCache(forID: contact.id, onContext: context) {
							allCached.remove(cachedConnection)
							cachedConnection.updateFromProfile(contact)
						} else {
							_ = ConnectionContact(connectionProfile: contact, context: context)
						}
					}

					allCached.forEach { context.delete($0) }
				}
				try CoreDataStack.shared.save(context: context)
			} catch {
				NSLog("Cache not updated: \(error)")
			}
			completion()
		}
	}

	private func allCachedContacts(onContext context: NSManagedObjectContext) -> [ConnectionContact] {
		let fetchRequest: NSFetchRequest<ConnectionContact> = ConnectionContact.fetchRequest()
		var allConnections: [ConnectionContact] = []
		context.performAndWait {
			do {
				allConnections = try context.fetch(fetchRequest)
			} catch {
				NSLog("error fetching from cache: \(error)")
			}
		}
		return allConnections

	}

	private func getContactFromCache(forID id: String, onContext context: NSManagedObjectContext) -> ConnectionContact? {
		let fetchRequest: NSFetchRequest<ConnectionContact> = ConnectionContact.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "id == %@", id as NSString)
		var result: ConnectionContact?
		context.performAndWait {
			do {
				result = try context.fetch(fetchRequest).first
			} catch {
				NSLog("error fetching from cache: \(error)")
			}
		}
		return result
	}

	// MARK: - Utility
	func clearCache(completion: ((Error?) -> Void)? = nil) {

		let fetchRequest: NSFetchRequest<ConnectionContact> = ConnectionContact.fetchRequest()

		let context = CoreDataStack.shared.container.newBackgroundContext()
		context.perform {
			do {
				let allCacheItems = try context.fetch(fetchRequest)
				allCacheItems.forEach { context.delete($0) }
				try CoreDataStack.shared.save(context: context)
				completion?(nil)
			} catch {
				NSLog("Error clearing database: \(error)")
				completion?(error)
			}
		}
	}
}
