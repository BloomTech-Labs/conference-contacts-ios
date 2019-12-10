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

	var socialType: SocialButton.SocialPlatform {
		switch type {
		case .email:
			return .email
		case .phone:
			return .phone
		case .social:
			return .twitter
		}
	}
}

extension ProfileNugget {
	init(value: String, type: ProfileFieldType, privacy: ProfileFieldPrivacy = .connected, preferredContact: Bool = false) {
		self.id = nil
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
