//
//  ProfileFieldPrivacy.swift
//  swaap
//
//  Created by Michael Redig on 12/4/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation

/// As the app is, there's not really much point to `public` right now.
enum ProfileFieldPrivacy: String, Codable, Hashable {
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let rawValue = try container.decode(String.self)
		let lcValue = rawValue.lowercased()
		
		guard let decoded = ProfileFieldPrivacy(rawValue: lcValue) else {
			throw ProfileDecodingError.unknownValue(value: rawValue)
		}
		self = decoded
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(rawValue.uppercased())
	}
	
	case `public`
	case `private`
}
