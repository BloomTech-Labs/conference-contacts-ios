//
//  Contact.swift
//  swaap
//
//  Created by Michael Redig on 12/18/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation

/// Currently used ephemerally. JSON arrives in this form, its data is cached in CoreData, then the instances are discarded.
struct Contact: Codable, Hashable {
	let id: String
	let sender: UserProfile?
	let receiver: UserProfile?
	let status: ContactConnectionStatus
	var connectedUser: UserProfile {
		// there has to be one or the other...
		sender ?? receiver ?? .zombie
	}
	let senderLat: Float?
	let senderLon: Float?
	let receiverLat: Float?
	let receiverLon: Float?
    let senderNote: String?
    let receiverNote: String?
    let senderEvent: String?
    let receiverEvent: String?
}


struct ContactContainer: Decodable {
	enum CodingKeys: String, CodingKey {
		case data
		case user
		case sentConnections
		case receivedConnections
	}

	/// All CONNECTED status connections
	let connections: [Contact]
	/// All connections user initiated, pending, connected, blocked
	let sentConnections: [UserProfile]
	/// All connections user received, pending, connected, blocked
	let receivedConnections: [UserProfile]
	/// All pending connections, sent or received
	let pendingReceivedConnections: [Contact]
	let pendingSentConnections: [Contact]

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
		let userContainer = try dataContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .user)
		let sentConnections = try userContainer.decode([Contact].self, forKey: .sentConnections)
		let receivedConnections = try userContainer.decode([Contact].self, forKey: .receivedConnections)
		let allConnections = sentConnections + receivedConnections
		let pendingConnections = allConnections.filter { $0.status == .pending }
		self.connections = allConnections.filter { $0.status == .connected }
		self.sentConnections = sentConnections.compactMap { $0.sender }
		self.receivedConnections = receivedConnections.compactMap { $0.receiver }
		self.pendingReceivedConnections = pendingConnections.compactMap { $0.sender != nil ? $0 : nil }
		self.pendingSentConnections = pendingConnections.compactMap { $0.receiver != nil ? $0 : nil }
	}
}
