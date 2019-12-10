//
//  ProfileNugget.swift
//  swaap
//
//  Created by Michael Redig on 12/4/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation

struct ProfileNugget: Codable, Hashable {
	let id: String?
	let value: String
	let type: ProfileFieldType
	let privacy: ProfileFieldPrivacy
	let preferredContact: Bool
}

struct MutateProfileNugget: Codable, Hashable {
	let value: String
	let type: ProfileFieldType
	let privacy: ProfileFieldPrivacy
	let preferredContact: Bool
}

extension MutateProfileNugget {
	init(nugget: ProfileNugget) {
		value = nugget.value
		type = nugget.type
		privacy = nugget.privacy
		preferredContact = nugget.preferredContact
	}
}
