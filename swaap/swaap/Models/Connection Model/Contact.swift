//
//  Contact.swift
//  swaap
//
//  Created by Michael Redig on 12/18/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation

struct Contact: Codable, Hashable {
	let id: String
	let sender: UserProfile?
	let receiver: UserProfile?
	let status: ContactConnectionStatus
}


struct ContactContainer: Decodable {
	enum CodingKeys: String, CodingKey {
		case data
		case user
		case sentConnections
		case receivedConnections
	}

	/// All CONNECTED status connections
	let connections: [UserProfile]
	/// All connections user initiated, pending, connected, blocked
	let sentConnections: [UserProfile]
	/// All connections user received, pending, connected, blocked
	let receivedConnections: [UserProfile]
	/// All pending connections, sent or received
	let pendingConnections: [UserProfile]

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
		let userContainer = try dataContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .user)
		let sentConnections = try userContainer.decode([Contact].self, forKey: .sentConnections)
		let receivedConnections = try userContainer.decode([Contact].self, forKey: .receivedConnections)
		let allConnections = sentConnections + receivedConnections
		let connections = allConnections.filter { $0.status == .connected }
		let pendingConnections = allConnections.filter { $0.status == .pending }
		self.sentConnections = sentConnections.compactMap { $0.sender }
		self.receivedConnections = receivedConnections.compactMap { $0.receiver }
		self.connections = connections.compactMap { $0.sender ?? $0.receiver }
		self.pendingConnections = pendingConnections.compactMap { $0.sender ?? $0.receiver }
	}
}
