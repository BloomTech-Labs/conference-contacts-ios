//
//  ProfileFieldType.swift
//  swaap
//
//  Created by Michael Redig on 12/4/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation

enum ProfileFieldType: Codable, Hashable {
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let rawValue = try container.decode(String.self)
		let lcValue = rawValue.lowercased()

		switch lcValue {
		case "email":
			self = .email
		case "phone":
			self = .phone
		case "social":
			self = .social
		default:
			throw ProfileDecodingError.unknownValue(value: rawValue)
		}
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case .email:
			try container.encode("EMAIL")
		case .phone:
			try container.encode("PHONE")
		case .social:
			try container.encode("SOCIAL")
		}
	}

	case email
	case phone
	case social
}
