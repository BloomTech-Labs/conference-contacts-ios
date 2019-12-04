//
//  ProfileNugget.swift
//  swaap
//
//  Created by Michael Redig on 12/4/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation

struct ProfileNugget: Codable {
	let value: String
	let authID: String
	let type: ProfileFieldType
	let privacy: ProfileFieldPrivacy
	let preferredContact: Bool
}
