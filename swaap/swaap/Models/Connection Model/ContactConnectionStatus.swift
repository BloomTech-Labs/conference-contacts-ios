//
//  ContactConnectionStatus.swift
//  swaap
//
//  Created by Michael Redig on 12/18/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation

enum ContactConnectionStatus: String, Codable, Hashable, CaseIterable {
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let rawValue = try container.decode(String.self)
		let lcValue = rawValue.lowercased()

		guard let decoded = ContactConnectionStatus(rawValue: lcValue) else {
			throw ProfileDecodingError.unknownValue(value: rawValue)
		}
		self = decoded
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(rawValue.uppercased())
	}

	case pending
	case connected
	case blocked
}
