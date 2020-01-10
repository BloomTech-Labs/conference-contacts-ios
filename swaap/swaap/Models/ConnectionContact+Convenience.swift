//
//  ConnectionContact+Convenience.swift
//  swaap
//
//  Created by Michael Redig on 12/18/19.
//  Copyright © 2019 swaap. All rights reserved.
//
// disabling because this instance is not comparing two of the same type, but of differing types
//swiftlint:disable static_operator

import Foundation
import CoreData
import CoreLocation

enum ContactPendingStatus: Int16 {
	case pendingSent
	case pendingReceived
	case connected

	init(with value: Int16) {
		switch value {
		case 0:
			self = .pendingSent
		case 1:
			self = .pendingReceived
		default:
			self = .connected
		}
	}
}

struct MeetingCoordinate {
	let coordinate: CLLocationCoordinate2D
	let distance: CLLocationDistance

	init?(coordinate: CLLocationCoordinate2D?, dist: Double?) {
		guard let coordinate = coordinate, let dist = dist else { return nil }
		guard dist >= 0 else { return nil }
		self.coordinate = coordinate
		distance = dist
	}
}

extension ConnectionContact {
	var contactProfile: UserProfile? {
		UserProfile(from: self)
	}

	var meetingCoordinate: MeetingCoordinate? {
		MeetingCoordinate(coordinate: CLLocationCoordinate2D(latitude: meetingLat, longitude: meetingLong), dist: meetingDistance)
	}

	private convenience init(id: String,
							 authID: String?,
							 name: String,
							 connectionStatus: Int16,
							 connectionID: String,
							 pictureURL: URL,
							 birthdate: String?,
							 location: String?,
							 industry: String?,
							 jobTitle: String?,
							 tagline: String?,
							 bio: String?,
							 meetingCoordinate: MeetingCoordinate?,
							 connectionMethods: [ConnectionContactMethod],
							 context: NSManagedObjectContext) {
		self.init(context: context)
		self.id = id
		self.authID = authID
		self.name = name
		self.connectionStatus = connectionStatus
		self.connectionID = connectionID
		self.pictureURL = pictureURL
		self.birthdate = birthdate
		self.location = location
		self.industry = industry
		self.jobTitle = jobTitle
		self.tagline = tagline
		self.bio = bio
		if let meetingCoordinate = meetingCoordinate {
			self.meetingLat = meetingCoordinate.coordinate.latitude
			self.meetingLong = meetingCoordinate.coordinate.longitude
			self.meetingDistance = meetingCoordinate.distance
		}
		let profileConnectionMethods = NSOrderedSet(array: connectionMethods)
		addToProfileContactMethods(profileConnectionMethods)
	}

	convenience init(connectionProfile: UserProfile,
					 connectionStatus: ContactPendingStatus,
					 connectionID: String,
					 meetingCoordinate: MeetingCoordinate?,
					 context: NSManagedObjectContext) {
		let connectionMethods = connectionProfile.profileContactMethods.map { ConnectionContactMethod(profileContactMethod: $0, context: context) }
		self.init(id: connectionProfile.id,
				  authID: connectionProfile.authID,
				  name: connectionProfile.name,
				  connectionStatus: connectionStatus.rawValue,
				  connectionID: connectionID,
				  pictureURL: connectionProfile.pictureURL,
				  birthdate: connectionProfile.birthdate,
				  location: connectionProfile.location,
				  industry: connectionProfile.industry,
				  jobTitle: connectionProfile.jobTitle,
				  tagline: connectionProfile.tagline,
				  bio: connectionProfile.bio,
				  meetingCoordinate: meetingCoordinate,
				  connectionMethods: connectionMethods,
				  context: context)
	}

	func updateFromProfile(_ userProfile: UserProfile, connectionStatus: ContactPendingStatus, connectionID: String, meetingCoordinate: MeetingCoordinate?) {
		guard userProfile.id == id else { return }
		authID = userProfile.authID
		name = userProfile.name
		pictureURL = userProfile.pictureURL
		birthdate = userProfile.birthdate
		location = userProfile.location
		industry = userProfile.industry
		jobTitle = userProfile.jobTitle
		tagline = userProfile.tagline
		bio = userProfile.bio
		if let meetingCoordinate = meetingCoordinate {
			self.meetingLat = meetingCoordinate.coordinate.latitude
			self.meetingLong = meetingCoordinate.coordinate.longitude
			self.meetingDistance = meetingCoordinate.distance
		}
		self.connectionStatus = connectionStatus.rawValue
		self.connectionID = connectionID

		if let existingContactMethods = profileContactMethods {
			removeFromProfileContactMethods(existingContactMethods)
		}
		guard let context = managedObjectContext else { return }
		let newContactMethods = userProfile.profileContactMethods.map { ConnectionContactMethod(profileContactMethod: $0, context: context) }
		addToProfileContactMethods(NSOrderedSet(array: newContactMethods))
	}
}

func == (lhs: ConnectionContact, rhs: UserProfile) -> Bool {
	let contactMethods = lhs.profileContactMethods?.compactMap { ($0 as? ConnectionContactMethod)?.profileContactMethod } ?? []

	return lhs.id == rhs.id &&
		lhs.authID == rhs.authID &&
		lhs.name == rhs.name &&
		lhs.pictureURL == rhs.pictureURL &&
		lhs.birthdate == rhs.birthdate &&
		lhs.location == rhs.location &&
		lhs.industry == rhs.industry &&
		lhs.jobTitle == rhs.jobTitle &&
		lhs.tagline == rhs.tagline &&
		lhs.bio == rhs.bio &&
		contactMethods == rhs.profileContactMethods
}

func == (lhs: UserProfile, rhs: ConnectionContact) -> Bool {
	rhs == lhs
}

func != (lhs: ConnectionContact, rhs: UserProfile) -> Bool {
	!(lhs == rhs)
}

func != (lhs: UserProfile, rhs: ConnectionContact) -> Bool {
	rhs != lhs
}
