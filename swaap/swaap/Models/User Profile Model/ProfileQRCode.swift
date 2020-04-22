//
//  ProfileQRCode.swift
//  swaap
//
//  Created by Michael Redig on 12/18/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation

/// Used specially for retrieving QR data from GraphQL
struct ProfileQRCodeContainer: Decodable {
	let qrCode: ProfileQRCode

	enum CodingKeys: String, CodingKey {
		case data
		case qrcode
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
		self.qrCode = try dataContainer.decode(ProfileQRCode.self, forKey: .qrcode)
	}
}

/// Stores data for generating a QR code.
struct ProfileQRCode: Codable, Hashable {
	let id: String
	let label: String
	let scans: Int
	let user: UserProfile?

	init(id: String, label: String, scans: Int, user: UserProfile? = nil) {
		self.id = id
		self.label = label
		self.scans = scans
		self.user = user
	}
}
