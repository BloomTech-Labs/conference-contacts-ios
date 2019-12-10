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
	var preferredContact: Bool

	init(id: String? = nil, value: String, type: ProfileFieldType, privacy: ProfileFieldPrivacy = .connected, preferredContact: Bool = false) {
		self.id = id
		self.value = value
		self.type = type
		self.privacy = privacy
		self.preferredContact = preferredContact
	}
}


extension Array where Element == ProfileNugget {
	var preferredContact: ProfileNugget? {
		first(where: { $0.preferredContact })
	}
}
