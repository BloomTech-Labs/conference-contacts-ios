//
//  UserProfile.swift
//  swaap
//
//  Created by Michael Redig on 12/4/19.
//  Copyright © 2019 swaap. All rights reserved.
//
//swiftlint:disable identifier_name

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

struct UserProfile: Codable, Hashable {

	enum CodingKeys: String, CodingKey {
		case id
		case authID = "authId"
		case name
		case pictureString = "picture"
		case birthdate
		case location
		case industry
		case jobTitle = "jobtitle"
		case tagline
		case bio
		case _profileContactMethods = "profile"
		case _qrCodes = "qrcodes"
	}

	let id: String
	let authID: String?
	var name: String
	private var pictureString: String?
	var birthdate: String?
	var location: String?
	var industry: String?
	var jobTitle: String?
	var tagline: String?
	var bio: String?
	private var _profileContactMethods: [ProfileContactMethod]?
	var profileContactMethods: [ProfileContactMethod] {
		get { _profileContactMethods ?? [] }
		set { _profileContactMethods = newValue }
	}
	private var _qrCodes: [ProfileQRCode]?
	var qrCodes: [ProfileQRCode] {
		get { _qrCodes ?? [] }
		set { _qrCodes = newValue }
	}

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

extension UserProfile {
	init?(from connectionContact: ConnectionContact) {
		guard let id = connectionContact.id,
			let name = connectionContact.name,
			let pictureURL = connectionContact.pictureURL else { return nil }
		self.id = id
		self.authID = connectionContact.authID
		self.bio = connectionContact.bio
		self.birthdate = connectionContact.birthdate
		self.industry = connectionContact.industry
		self.jobTitle = connectionContact.jobTitle
		self.tagline = connectionContact.tagline
		self.name = name
		self.profileContactMethods = connectionContact.profileContactMethods?.compactMap { ($0 as? ConnectionContactMethod)?.profileContactMethod } ?? []
		self.pictureURL = pictureURL
	}
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
	let tagline: String?
	let bio: String?

	init(name: String? = nil,
		 picture: URL? = nil,
		 birthdate: String? = nil,
		 location: String? = nil,
		 industry: String? = nil,
		 jobtitle: String? = nil,
		 tagline: String? = nil,
		 bio: String? = nil) {
		self.name = name
		self.picture = picture
		self.birthdate = birthdate
		self.location = location
		self.industry = industry
		self.jobtitle = jobtitle
		self.tagline = tagline
		self.bio = bio
	}

	init(userProfile: UserProfile) {
		name = userProfile.name
		picture = userProfile.pictureURL
		birthdate = userProfile.birthdate
		location = userProfile.location
		industry = userProfile.industry
		jobtitle = userProfile.jobTitle
		tagline = userProfile.tagline
		bio = userProfile.bio
	}
}
