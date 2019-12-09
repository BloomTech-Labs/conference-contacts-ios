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
	let preferredContact: Bool
}
