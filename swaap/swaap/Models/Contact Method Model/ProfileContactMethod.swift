//
//  ProfileNugget.swift
//  swaap
//
//  Created by Michael Redig on 12/4/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation

/// Represents a single contact method for a user
struct ProfileContactMethod: Codable, Hashable {
	let id: String?
	let value: String
	let type: ProfileFieldType
	var privacy: ProfileFieldPrivacy
	var preferredContact: Bool

	var infoNugget: ProfileInfoNugget {
		ProfileInfoNugget(type: type, value: value)
	}

	init(id: String? = nil, value: String, type: ProfileFieldType, privacy: ProfileFieldPrivacy = .private, preferredContact: Bool = false) {
		self.id = id
		self.value = value
		self.type = type
		self.privacy = privacy
		self.preferredContact = preferredContact
	}
}

/// Can represent either contact information or static user information like their name, industry, bio, etc.
struct ProfileInfoNugget {
	var type: ProfileFieldType?
	var value: String

	var contactMethod: ProfileContactMethod? {
		guard let type = type else { return nil }
		return ProfileContactMethod(value: value, type: type)
	}

	var displayValue: String {
		switch type {
		case .twitter, .instagram:
			return "@\(value)"
		default:
			return value
		}
	}
}

extension Array where Element == ProfileContactMethod {
	var preferredContact: ProfileContactMethod? {
		first(where: { $0.preferredContact })
	}
}

struct MutateProfileContactMethod: Codable, Hashable {
	let id: String?
	let value: String
	let type: ProfileFieldType
	let privacy: ProfileFieldPrivacy
	let preferredContact: Bool
}

extension MutateProfileContactMethod {
	init(contactMethod: ProfileContactMethod) {
		id = contactMethod.id
		value = contactMethod.value
		type = contactMethod.type
		privacy = contactMethod.privacy
		preferredContact = contactMethod.preferredContact
	}
}
