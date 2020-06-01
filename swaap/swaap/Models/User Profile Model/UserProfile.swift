//
//  UserProfile.swift
//  swaap
//
//  Created by Michael Redig on 12/4/19.
//  Copyright © 2019 swaap. All rights reserved.
//
//swiftlint:disable identifier_name

import Foundation

/// Used only for fetching and decoding JSON from the server.
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


/// Used both for decoding JSON from the server and passing data around the app. Note that while the ProfileViewController
/// utilizes this for displaying both user and contact data, contacts are not cached on disk in this format. Instead,
/// they are cached as a CoreData class. Convenience methods are available to convert between them, but be aware that they are not lossless.
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
        case notes //added here
        case events // added events here
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
    var notes: String? //added here
    var events: String? // added events here
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
        self.notes = connectionContact.notes //added here
        self.events = connectionContact.events // added events here
		self.birthdate = connectionContact.birthdate
		self.industry = connectionContact.industry
		self.jobTitle = connectionContact.jobTitle
		self.tagline = connectionContact.tagline
		self.location = connectionContact.location
		self.name = name
		self.profileContactMethods = connectionContact.profileContactMethods?.compactMap { ($0 as? ConnectionContactMethod)?.profileContactMethod } ?? []
		self.pictureURL = pictureURL
	}

	static let zombie: UserProfile = UserProfile(id: "zombieID",
												 authID: nil,
												 name: "Zombie Connection",
												 pictureString: nil,
												 birthdate: nil,
												 location: nil,
												 industry: nil,
												 jobTitle: nil,
												 tagline: nil,
												 bio: nil,
                                                 notes: nil, // added here
                                                 events: nil, // added evnets here
												 _profileContactMethods: nil,
												 _qrCodes: nil,
												 photoData: nil)
}

/// Used specially for making a createUser mutation on GraphQL
struct CreateUser: Codable {
	let name: String
	let picture: URL?
	let email: String
}

/// Used specially for making a updateUser mutation on GraphQL
struct UpdateUser: Codable {
	let name: String?
	let picture: URL?
	let birthdate: String?
	let location: String?
	let industry: String?
	let jobtitle: String?
	let tagline: String?
	let bio: String?
    let notes: String?//added here
    let events: String? //added events here

	init(name: String? = nil,
		 picture: URL? = nil,
		 birthdate: String? = nil,
		 location: String? = nil,
		 industry: String? = nil,
		 jobtitle: String? = nil,
		 tagline: String? = nil,
		 bio: String? = nil,
         notes: String?,
         events: String?) {
		self.name = name
		self.picture = picture
		self.birthdate = birthdate
		self.location = location
		self.industry = industry
		self.jobtitle = jobtitle
		self.tagline = tagline
		self.bio = bio
        self.notes = notes //added here
        self.events = events //added events here
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
        notes = userProfile.notes // added here
        events = userProfile.events // added events 
	}
}
