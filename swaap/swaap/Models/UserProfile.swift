//
//  UserProfile.swift
//  swaap
//
//  Created by Michael Redig on 12/4/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation

struct UserProfile: Codable, Equatable {
	let id: String
	let authID: String
	let name: String
	let picture: URL?
	let birthdate: String?
	let gender: ProfileUserGender?
	let industry: String?
	let jobtitle: String?
	let bio: String?
}

struct CreateUser: Codable {
	let sub: String
	let name: String
	let picture: URL?
	let email: String
}
