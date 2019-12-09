//
//  ProfileNugget.swift
//  swaap
//
//  Created by Michael Redig on 12/4/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation

struct ProfileNugget: Codable, Hashable {
	let id: String
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
			return .instagram
		}
	}
}
