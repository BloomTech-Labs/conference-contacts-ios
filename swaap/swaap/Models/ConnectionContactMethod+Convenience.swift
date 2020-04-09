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

extension ConnectionContactMethod {
	private convenience init(id: String?, value: String?, type: String?, preferredContact: Bool, context: NSManagedObjectContext) {
		self.init(context: context)
		self.id = id
		self.value = value
		self.type = type
		self.preferredContact = preferredContact
	}

	convenience init(profileContactMethod: ProfileContactMethod, context: NSManagedObjectContext) {
		self.init(id: profileContactMethod.id,
				  value: profileContactMethod.value,
				  type: profileContactMethod.type.rawValue,
				  preferredContact: profileContactMethod.preferredContact,
				  context: context)
	}

	var profileContactMethod: ProfileContactMethod? {
		guard let value = value, let type = ProfileFieldType(rawValue: type ?? "") else { return nil }
		return ProfileContactMethod(id: id,
									value: value,
									type: type,
									privacy: .private, // provided just as dummy value - not evaluated when comparing
			preferredContact: preferredContact)
	}
}

func == (lhs: ConnectionContactMethod, rhs: ProfileContactMethod) -> Bool {
	lhs.id == rhs.id &&
		lhs.preferredContact == rhs.preferredContact &&
		lhs.value == rhs.value &&
		lhs.type == rhs.type.rawValue
}

func == (lhs: ProfileContactMethod, rhs: ConnectionContactMethod) -> Bool {
	rhs == lhs
}

func != (lhs: ConnectionContactMethod, rhs: ProfileContactMethod) -> Bool {
	!(lhs == rhs)
}

func != (lhs: ProfileContactMethod, rhs: ConnectionContactMethod) -> Bool {
	rhs != lhs
}
