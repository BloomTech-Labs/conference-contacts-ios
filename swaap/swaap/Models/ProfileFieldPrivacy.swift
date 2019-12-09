//
//  ProfileFieldPrivacy.swift
//  swaap
//
//  Created by Michael Redig on 12/4/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation

enum ProfileFieldPrivacy: Codable, Hashable {
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let rawValue = try container.decode(String.self)
		let lcValue = rawValue.lowercased()

		switch lcValue {
		case "public":
			self = .public
		case "private":
			self = .private
		case "connected":
			self = .connected
		default:
			throw ProfileDecodingError.unknownValue(value: rawValue)
		}
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case .public:
			try container.encode("PUBLIC")
		case .private:
			try container.encode("PRIVATE")
		case .connected:
			try container.encode("CONNECTED")
		}
	}

	case `public`
	case `private`
	case connected
}
