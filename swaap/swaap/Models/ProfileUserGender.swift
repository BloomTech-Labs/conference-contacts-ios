//
//  ProfileUserGender.swift
//  swaap
//
//  Created by Michael Redig on 12/4/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation

enum ProfileUserGender: Codable {
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let rawValue = try container.decode(String.self)
		let lcValue = rawValue.lowercased()

		switch lcValue {
		case "male":
			self = .male
		case "female":
			self = .female
		case "nonbinary":
			self = .nonbinary
		default:
			throw ProfileDecodingError.unknownValue(value: rawValue)
		}
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case .male:
			try container.encode("MALE")
		case .female:
			try container.encode("FEMALE")
		case .nonbinary:
			try container.encode("NONBINARY")
		}
	}

	case male
	case female
	case nonbinary
}
