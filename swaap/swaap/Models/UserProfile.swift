//
//  UserProfile.swift
//  swaap
//
//  Created by Michael Redig on 12/4/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import Foundation

struct UserProfileContainer: Decodable {
	let userProfile: UserProfile

	enum CodingKeys: String, CodingKey {
		case data
		case user
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
		self.userProfile = try dataContainer.decode(UserProfile.self, forKey: .user)
	}
}

struct UserProfile: Codable, Equatable {

	enum CodingKeys: String, CodingKey {
		case id
		case authID = "authId"
		case name
		case pictureString = "picture"
		case birthdate
		case gender
		case industry
		case jobtitle
		case bio
	}

	let id: String
	let authID: String
	let name: String
	private let pictureString: String?
	let birthdate: String?
	let gender: ProfileUserGender?
	let industry: String?
	let jobtitle: String?
	let bio: String?

	var pictureURL: URL {
		URL(string: pictureString ?? "") ?? URL(string: "https://placekitten.com/1000/1000")!
	}
}

struct CreateUser: Codable {
	let name: String
	let picture: URL?
	let email: String
}
