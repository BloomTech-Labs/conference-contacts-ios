//
//  ConnectionContact+CoreDataProperties.swift
//  swaap
//
//  Created by Marlon Raskin on 1/7/20.
//  Copyright © 2020 swaap. All rights reserved.
//
//

import Foundation
import CoreData


extension ConnectionContact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ConnectionContact> {
        return NSFetchRequest<ConnectionContact>(entityName: "ConnectionContact")
    }

    @NSManaged public var authID: String?
    @NSManaged public var bio: String?
    @NSManaged public var birthdate: String?
    @NSManaged public var connectionID: String?
    @NSManaged public var connectionStatus: Int16
    @NSManaged public var id: String?
    @NSManaged public var industry: String?
    @NSManaged public var jobTitle: String?
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var pictureURL: URL?
    @NSManaged public var tagline: String?
    @NSManaged public var meetingLat: Double
    @NSManaged public var meetingLong: Double
    @NSManaged public var meetingDistance: Double
    @NSManaged public var profileContactMethods: NSOrderedSet?

	@objc var section: String? {
		String(name?.uppercased().first ?? " ")
	}
}

// MARK: Generated accessors for profileContactMethods
extension ConnectionContact {

    @objc(insertObject:inProfileContactMethodsAtIndex:)
    @NSManaged public func insertIntoProfileContactMethods(_ value: ConnectionContactMethod, at idx: Int)

    @objc(removeObjectFromProfileContactMethodsAtIndex:)
    @NSManaged public func removeFromProfileContactMethods(at idx: Int)

    @objc(insertProfileContactMethods:atIndexes:)
    @NSManaged public func insertIntoProfileContactMethods(_ values: [ConnectionContactMethod], at indexes: NSIndexSet)

    @objc(removeProfileContactMethodsAtIndexes:)
    @NSManaged public func removeFromProfileContactMethods(at indexes: NSIndexSet)

    @objc(replaceObjectInProfileContactMethodsAtIndex:withObject:)
    @NSManaged public func replaceProfileContactMethods(at idx: Int, with value: ConnectionContactMethod)

    @objc(replaceProfileContactMethodsAtIndexes:withProfileContactMethods:)
    @NSManaged public func replaceProfileContactMethods(at indexes: NSIndexSet, with values: [ConnectionContactMethod])

    @objc(addProfileContactMethodsObject:)
    @NSManaged public func addToProfileContactMethods(_ value: ConnectionContactMethod)

    @objc(removeProfileContactMethodsObject:)
    @NSManaged public func removeFromProfileContactMethods(_ value: ConnectionContactMethod)

    @objc(addProfileContactMethods:)
    @NSManaged public func addToProfileContactMethods(_ values: NSOrderedSet)

    @objc(removeProfileContactMethods:)
    @NSManaged public func removeFromProfileContactMethods(_ values: NSOrderedSet)

}
