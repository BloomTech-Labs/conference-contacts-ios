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
		case location
		case industry
		case jobtitle
		case bio
		case profileContactMethods = "profile"
	}

	let id: String
	let authID: String
	var name: String
	private var pictureString: String?
	var birthdate: String?
	var location: String?
	var industry: String?
	var jobtitle: String?
	var bio: String?
	var profileContactMethods: [ProfileContactMethod]

	var pictureURL: URL {
		get {
			URL(string: pictureString ?? "") ?? URL(string: "https://placekitten.com/1000/1000")!
		}
		set {
			pictureString = newValue.absoluteString
		}
	}
	var photoData: Data?

}

struct CreateUser: Codable {
	let name: String
	let picture: URL?
	let email: String
}

struct UpdateUser: Codable {
	let name: String?
	let picture: URL?
	let birthdate: String?
	let location: String?
	let industry: String?
	let jobtitle: String?
	let bio: String?

	init(name: String? = nil,
		 picture: URL? = nil,
		 birthdate: String? = nil,
		 location: String? = nil,
		 industry: String? = nil,
		 jobtitle: String? = nil,
		 bio: String? = nil) {
		self.name = name
		self.picture = picture
		self.birthdate = birthdate
		self.location = location
		self.industry = industry
		self.jobtitle = jobtitle
		self.bio = bio
	}

	init(userProfile: UserProfile) {
		name = userProfile.name
		picture = userProfile.pictureURL
		birthdate = userProfile.birthdate
		location = userProfile.location
		industry = userProfile.industry
		jobtitle = userProfile.jobtitle
		bio = userProfile.bio
	}
}
