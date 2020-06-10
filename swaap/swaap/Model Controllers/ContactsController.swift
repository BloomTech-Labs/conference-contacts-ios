//
//  ContactsController.swift
//  swaap
//
//  Created by Michael Redig on 11/12/19.
//  Copyright © 2019 swaap. All rights reserved.
//
//swiftlint:disable function_body_length

import Foundation
import NetworkHandler
import CoreData
import CoreLocation

protocol ContactsAccessor: AnyObject {
	var contactsController: ContactsController? { get set }
}

class ContactsController {
	// MARK: - Properties
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

	var allContacts: [ConnectionContact] {
		allCachedContacts(onContext: .mainContext)
	}

	var pendingIncomingRequests: [ConnectionContact] {
		allCachedContacts(onContext: .mainContext, status: .pendingReceived)
	}

	var pendingOutgoingRequests: [ConnectionContact] {
		allCachedContacts(onContext: .mainContext, status: .pendingSent)
	}

	// MARK: - Lifecycle
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

	// MARK: - Contacts
	// MARK: networking
	func fetchUser(with id: String, session: NetworkLoader = URLSession.shared, completion: @escaping (Result<UserProfile, NetworkError>) -> Void) {
		guard var request = authManager.networkAuthRequestCommon(for: graphqlURL) else {
			completion(.failure(NetworkError.unspecifiedError(reason: "Request was not attainable.")))
			return
		}

		let query = SwaapGQLQueries.connectionFetchSingleUserQuery
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
		networkHandler.transferMahCodableDatas(with: request, session: session) { (result: Result<UserProfileContainer, NetworkError>) in
			do {
				let container = try result.get()
				completion(.success(container.userProfile))
			} catch {
				NSLog("Error fetching requested user: \(error)")
				completion(.failure(error as? NetworkError ?? NetworkError.otherError(error: error)))
			}
		}
	}

	func fetchAllContacts(session: NetworkLoader = URLSession.shared, completion: @escaping (Result<ContactContainer, NetworkError>) -> Void) {
		guard var request = authManager.networkAuthRequestCommon(for: graphqlURL) else {
			completion(.failure(NetworkError.unspecifiedError(reason: "Request was not attainable.")))
			return
		}

		let query = SwaapGQLQueries.connectionFetchAllContactsQuery
		let graphObject = GQuery(query: query)
		do {
			request.httpBody = try graphObject.jsonData()
		} catch {
			NSLog("Failed encoding graph object: \(error)")
			completion(.failure(.dataCodingError(specifically: error, sourceData: nil)))
			return
		}

		request.expectedResponseCodes = [200]
		networkHandler.transferMahCodableDatas(with: request, session: session, completion: completion)
	}

	// MARK: CoreData
	func updateContactCache(completion: @escaping () -> Void = {}) {
		fetchAllContacts { [weak self] result in
			guard let self = self else {
				completion()
				return
			}
			do {
				let container = try result.get()
				let connections = container.connections
				let pendingSent = container.pendingSentConnections
				let pendingReceived = container.pendingReceivedConnections
				let context = CoreDataStack.shared.container.newBackgroundContext()
				context.performAndWait {
					// tracking changes - once all contacts have been updated, any remaining in this set have been deleted as connections
					var allCached = Set(self.allCachedContacts(onContext: context))

					let updateContactClosure: ([Contact], ContactPendingStatus) -> Void = { contacts, status in
						for contact in contacts {
							let userConnection = contact.connectedUser
							let meetingCoordinate: MeetingCoordinate?
							if let senderLat = contact.senderLat, let senderLong = contact.senderLon,
								let receiverLat = contact.receiverLat, let receiverLong = contact.receiverLon {
								// Coordinates
								let senderCoord = CLLocationCoordinate2D(latitude: Double(senderLat), longitude: Double(senderLong))
								let receiverCoord = CLLocationCoordinate2D(latitude: Double(receiverLat), longitude: Double(receiverLong))
								let midPoint = senderCoord.midPoint(from: receiverCoord)
								// Distance
								let senderLocation = CLLocation(latitude: senderCoord.latitude, longitude: senderCoord.longitude)
								let midPointLocation = CLLocation(latitude: midPoint.latitude, longitude: midPoint.longitude)
								let distance = senderLocation.distance(from: midPointLocation)
								// Result
								meetingCoordinate = MeetingCoordinate(coordinate: midPoint, dist: distance)
							} else {
								meetingCoordinate = nil
							}
							if let cachedConnection = self.getContactFromCache(forID: userConnection.id, onContext: context) {
								allCached.remove(cachedConnection)
								cachedConnection.updateFromProfile(userConnection, connectionStatus: status, connectionID: contact.id, meetingCoordinate: meetingCoordinate)
							} else {
								_ = ConnectionContact(connectionProfile: userConnection,
													  connectionStatus: status,
													  connectionID: contact.id,
													  meetingCoordinate: meetingCoordinate,
													  context: context)
							}
						}
					}

					updateContactClosure(connections, .connected)
					updateContactClosure(pendingSent, .pendingSent)
					updateContactClosure(pendingReceived, .pendingReceived)

					allCached.forEach { context.delete($0) }
				}
				try CoreDataStack.shared.save(context: context)
			} catch {
				NSLog("Cache not updated: \(error)")
			}
			DispatchQueue.main.async {
				NotificationCenter.default.post(name: .contactsCacheUpdated, object: nil)
			}
			completion()
		}
	}

	private func allCachedContacts(onContext context: NSManagedObjectContext, status: ContactPendingStatus? = nil) -> [ConnectionContact] {
		let fetchRequest: NSFetchRequest<ConnectionContact> = ConnectionContact.fetchRequest()
		if let status = status {
			fetchRequest.predicate = NSPredicate(format: "connectionStatus == %i", status.rawValue)
		}
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

	// MARK: - QR Code
	@discardableResult func fetchQRCode(with id: String,
										session: NetworkLoader = URLSession.shared,
										completion: @escaping (Result<ProfileQRCode, NetworkError>) -> Void) -> URLSessionDataTask? {
		guard var request = authManager.networkAuthRequestCommon(for: graphqlURL) else {
			completion(.failure(NetworkError.unspecifiedError(reason: "Request was not attainable.")))
			return nil
		}

		let query = SwaapGQLQueries.connectionFetchQRCodeQuery
		let variables = ["id": id]

		let graphObject = GQuery(query: query, variables: variables)

		do {
			request.httpBody = try graphObject.jsonData()
		} catch {
			NSLog("Failed encoding graph object: \(error)")
			completion(.failure(.dataCodingError(specifically: error, sourceData: nil)))
			return nil
		}

		request.expectedResponseCodes = [200]
        return networkHandler.transferMahCodableDatas(with: request, session: session) { (result: Result<ProfileQRCodeContainer, NetworkError>) in
            do {
                let container = try result.get()
                completion(.success(container.qrCode))
            } catch {
                NSLog("Error fetching requested user: \(error)")
                completion(.failure(error as? NetworkError ?? NetworkError.otherError(error: error)))
            }
            } as? URLSessionDataTask
    }

	// MARK: - Connections (between users)
	func requestConnection(toUserID userID: String,
						   currentLocation: CLLocation,
						   session: NetworkLoader = URLSession.shared,
						   completion: @escaping (Result<GQLMutationResponse, NetworkError>) -> Void) {
		guard var request = authManager.networkAuthRequestCommon(for: graphqlURL) else {
			completion(.failure(NetworkError.unspecifiedError(reason: "Request was not attainable.")))
			return
		}
		let coords = currentLocation.coordinate

		let query = SwaapGQLQueries.connectionCreateMutation
		let variables = ["id": userID,
						 "coords": ["latitude": coords.latitude,
									"longitude": coords.longitude]] as [String: Any]

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

	func acceptConnection(toConnectionID connectionID: String,
						   currentLocation: CLLocation,
						   session: NetworkLoader = URLSession.shared,
						   completion: @escaping (Result<GQLMutationResponse, NetworkError>) -> Void) {
		guard var request = authManager.networkAuthRequestCommon(for: graphqlURL) else {
			completion(.failure(NetworkError.unspecifiedError(reason: "Request was not attainable.")))
			return
		}
		let coords = currentLocation.coordinate

		let query = SwaapGQLQueries.connectionAcceptMutation
		let variables = ["id": connectionID,
						 "coords": ["latitude": coords.latitude,
									"longitude": coords.longitude]] as [String: Any]

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
				NSLog("Error accepting connection to user: \(error)")
				completion(.failure(error as? NetworkError ?? NetworkError.otherError(error: error)))
			}
		}
	}

	func deleteConnection(toConnectionID connectionID: String,
						  session: NetworkLoader = URLSession.shared,
						  completion: @escaping (Result<GQLMutationResponse, NetworkError>) -> Void) {

		guard var request = authManager.networkAuthRequestCommon(for: graphqlURL) else {
			completion(.failure(NetworkError.unspecifiedError(reason: "Request was not attainable.")))
			return
		}

		let query = SwaapGQLQueries.connectionDeleteMutation
		let variables = ["id": connectionID] as [String: Any]
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
				NSLog("Error deleting connection to user: \(error)")
				completion(.failure(error as? NetworkError ?? NetworkError.otherError(error: error)))
			}
		}
	}

    // MARK: - Notes & Events
    //swiftlint:disable:next line_length
    func updateSenderNotes(toConnectionID connectionID: String, senderNote: String = "nil", receiverNote: String = "nil", session: NetworkLoader = URLSession.shared, completion: @escaping(Result<GQLMutationResponse, NetworkError>) -> Void) {
        guard var request = authManager.networkAuthRequestCommon(for: graphqlURL) else {
            completion(.failure(NetworkError.unspecifiedError(reason: "Request was not attainable.")))
            return
        }
        let query = SwaapGQLQueries.connectionUpdateSenderNote
        let variables = ["id": connectionID,
                         "sendNote": senderNote,
                         "receiveNote": receiverNote] as [String: Any]
        
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
                NSLog("Error updating sender note: \(error)")
                completion(.failure(error as? NetworkError ?? NetworkError.otherError(error: error)))
            }
        }
    }
    
    //swiftlint:disable:next line_length
    func updateReceiverNotes(toUserID userID: String, receiverNote: String, session: NetworkLoader = URLSession.shared, completion: @escaping(Result<GQLMutationResponse, NetworkError>) -> Void) {
        guard var request = authManager.networkAuthRequestCommon(for: graphqlURL) else {
            completion(.failure(NetworkError.unspecifiedError(reason: "Request was not attainable.")))
            return
        }
        let query = SwaapGQLQueries.connectionUpdateReceiverNote
        let variables = ["id": userID,
                         "receiveNote": receiverNote] as [String: Any]
        
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
                NSLog("Error updating receiver note: \(error)")
                completion(.failure(error as? NetworkError ?? NetworkError.otherError(error: error)))
            }
        }
    }
    
    //swiftlint:disable:next line_length
    func updateSenderEvents(toUserID userID: String, senderEvent: String, session: NetworkLoader = URLSession.shared, completion: @escaping(Result<GQLMutationResponse, NetworkError>) -> Void) {
        guard var request = authManager.networkAuthRequestCommon(for: graphqlURL) else {
            completion(.failure(NetworkError.unspecifiedError(reason: "Request was not attainable.")))
            return
        }
        let query = SwaapGQLQueries.connectionUpdateSenderNote
        let variables = ["id": userID,
                         "sendEvent": senderEvent] as [String: Any]
        
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
                NSLog("Error updating sender event: \(error)")
                completion(.failure(error as? NetworkError ?? NetworkError.otherError(error: error)))
            }
        }
    }
    
    //swiftlint:disable:next line_length
    func updateReceiverEvents(toUserID userID: String, receiverEvent: String, session: NetworkLoader = URLSession.shared, completion: @escaping(Result<GQLMutationResponse, NetworkError>) -> Void) {
        guard var request = authManager.networkAuthRequestCommon(for: graphqlURL) else {
            completion(.failure(NetworkError.unspecifiedError(reason: "Request was not attainable.")))
            return
        }
        let query = SwaapGQLQueries.connectionUpdateReceiverNote
        let variables = ["id": userID,
                         "receiveEvent": receiverEvent] as [String: Any]
        
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
                NSLog("Error updating receiver event: \(error)")
                completion(.failure(error as? NetworkError ?? NetworkError.otherError(error: error)))
            }
        }
    }
    
    func createNote(with text: String, context: NSManagedObjectContext) {
        let note = ConnectionContact(notes: text, context: context)
        try? CoreDataStack.shared.save(context: context)
    }
    
    func updateNote(note: ConnectionContact, with text: String, context: NSManagedObjectContext) {
        
    }
    
    func deleteNote(note: ConnectionContact, context: NSManagedObjectContext) {
        
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

extension NSNotification.Name {
	static let contactsCacheUpdated = NSNotification.Name("com.swaap.contactsCacheUpdated")
}
