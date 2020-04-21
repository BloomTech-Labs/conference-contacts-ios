## ConnectionContact

**public** *class*

```swift
public class ConnectionContact: NSManagedObject
```

No documentation



*Found in:*

* `swaap/Models/ConnectionContact+CoreDataClass.swift`


### Extension: ConnectionContact

**internal** *extension*

```swift
extension ConnectionContact
```

No documentation




* ##--Property/contactProfile/contactProfile--##
	***internal*** *instance property*
	No documentation
	```swift
	var contactProfile: UserProfile?
	```
	*Found in:*

* `swaap/Models/ConnectionContact+Convenience.swift`
* ##--Property/meetingCoordinate/meetingCoordinate--##
	***internal*** *instance property*
	No documentation
	```swift
	var meetingCoordinate: MeetingCoordinate?
	```
	*Found in:*

* `swaap/Models/ConnectionContact+Convenience.swift`
* ##--Method/init(id%3AauthID%3Aname%3AconnectionStatus%3AconnectionID%3ApictureURL%3Abirthdate%3Alocation%3Aindustry%3AjobTitle%3Atagline%3Abio%3AmeetingCoordinate%3AconnectionMethods%3Acontext%3A)/init(id:authID:name:connectionStatus:connectionID:pictureURL:birthdate:location:industry:jobTitle:tagline:bio:meetingCoordinate:connectionMethods:context:)--##
	***private*** *instance method*
	No documentation
	```swift
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
							 context: NSManagedObjectContext)
	```
	*Found in:*

* `swaap/Models/ConnectionContact+Convenience.swift`
* ##--Method/init(connectionProfile%3AconnectionStatus%3AconnectionID%3AmeetingCoordinate%3Acontext%3A)/init(connectionProfile:connectionStatus:connectionID:meetingCoordinate:context:)--##
	***internal*** *instance method*
	No documentation
	```swift
	convenience init(connectionProfile: UserProfile,
					 connectionStatus: ContactPendingStatus,
					 connectionID: String,
					 meetingCoordinate: MeetingCoordinate?,
					 context: NSManagedObjectContext)
	```
	*Found in:*

* `swaap/Models/ConnectionContact+Convenience.swift`
* ##--Method/updateFromProfile(_%3AconnectionStatus%3AconnectionID%3AmeetingCoordinate%3A)/updateFromProfile(_:connectionStatus:connectionID:meetingCoordinate:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func updateFromProfile(_ userProfile: UserProfile, connectionStatus: ContactPendingStatus, connectionID: String, meetingCoordinate: MeetingCoordinate?)
	```
	*Found in:*

* `swaap/Models/ConnectionContact+Convenience.swift`


### Extension: ConnectionContact

**internal** *extension*

```swift
extension ConnectionContact
```

No documentation




* ##--Source.Lang.Swift.Decl.Function.Method.Class/fetchRequest()/fetchRequest()--##
	***public*** *source.lang.swift.decl.function.method.class*
	No documentation
	```swift
	@nonobjc public class func fetchRequest() -> NSFetchRequest<ConnectionContact>
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Property/authID/authID--##
	***public*** *instance property*
	No documentation
	```swift
	@NSManaged public var authID: String?
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Property/bio/bio--##
	***public*** *instance property*
	No documentation
	```swift
	@NSManaged public var bio: String?
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Property/birthdate/birthdate--##
	***public*** *instance property*
	No documentation
	```swift
	@NSManaged public var birthdate: String?
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Property/connectionID/connectionID--##
	***public*** *instance property*
	No documentation
	```swift
	@NSManaged public var connectionID: String?
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Property/connectionStatus/connectionStatus--##
	***public*** *instance property*
	No documentation
	```swift
	@NSManaged public var connectionStatus: Int16
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Property/id/id--##
	***public*** *instance property*
	No documentation
	```swift
	@NSManaged public var id: String?
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Property/industry/industry--##
	***public*** *instance property*
	No documentation
	```swift
	@NSManaged public var industry: String?
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Property/jobTitle/jobTitle--##
	***public*** *instance property*
	No documentation
	```swift
	@NSManaged public var jobTitle: String?
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Property/location/location--##
	***public*** *instance property*
	No documentation
	```swift
	@NSManaged public var location: String?
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Property/name/name--##
	***public*** *instance property*
	No documentation
	```swift
	@NSManaged public var name: String?
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Property/pictureURL/pictureURL--##
	***public*** *instance property*
	No documentation
	```swift
	@NSManaged public var pictureURL: URL?
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Property/tagline/tagline--##
	***public*** *instance property*
	No documentation
	```swift
	@NSManaged public var tagline: String?
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Property/meetingLat/meetingLat--##
	***public*** *instance property*
	No documentation
	```swift
	@NSManaged public var meetingLat: Double
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Property/meetingLong/meetingLong--##
	***public*** *instance property*
	No documentation
	```swift
	@NSManaged public var meetingLong: Double
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Property/meetingDistance/meetingDistance--##
	***public*** *instance property*
	No documentation
	```swift
	@NSManaged public var meetingDistance: Double
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Property/profileContactMethods/profileContactMethods--##
	***public*** *instance property*
	No documentation
	```swift
	@NSManaged public var profileContactMethods: NSOrderedSet?
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Property/section/section--##
	***internal*** *instance property*
	No documentation
	```swift
	@objc var section: String?
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`


### Extension: ConnectionContact

**internal** *extension*

```swift
extension ConnectionContact
```

No documentation




* ##--Method/insertIntoProfileContactMethods(_%3Aat%3A)/insertIntoProfileContactMethods(_:at:)--##
	***public*** *instance method*
	No documentation
	```swift
	@NSManaged public func insertIntoProfileContactMethods(_ value: ConnectionContactMethod, at idx: Int)
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Method/removeFromProfileContactMethods(at%3A)/removeFromProfileContactMethods(at:)--##
	***public*** *instance method*
	No documentation
	```swift
	@NSManaged public func removeFromProfileContactMethods(at idx: Int)
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Method/insertIntoProfileContactMethods(_%3Aat%3A)/insertIntoProfileContactMethods(_:at:)--##
	***public*** *instance method*
	No documentation
	```swift
	@NSManaged public func insertIntoProfileContactMethods(_ values: [ConnectionContactMethod], at indexes: NSIndexSet)
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Method/removeFromProfileContactMethods(at%3A)/removeFromProfileContactMethods(at:)--##
	***public*** *instance method*
	No documentation
	```swift
	@NSManaged public func removeFromProfileContactMethods(at indexes: NSIndexSet)
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Method/replaceProfileContactMethods(at%3Awith%3A)/replaceProfileContactMethods(at:with:)--##
	***public*** *instance method*
	No documentation
	```swift
	@NSManaged public func replaceProfileContactMethods(at idx: Int, with value: ConnectionContactMethod)
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Method/replaceProfileContactMethods(at%3Awith%3A)/replaceProfileContactMethods(at:with:)--##
	***public*** *instance method*
	No documentation
	```swift
	@NSManaged public func replaceProfileContactMethods(at indexes: NSIndexSet, with values: [ConnectionContactMethod])
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Method/addToProfileContactMethods(_%3A)/addToProfileContactMethods(_:)--##
	***public*** *instance method*
	No documentation
	```swift
	@NSManaged public func addToProfileContactMethods(_ value: ConnectionContactMethod)
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Method/removeFromProfileContactMethods(_%3A)/removeFromProfileContactMethods(_:)--##
	***public*** *instance method*
	No documentation
	```swift
	@NSManaged public func removeFromProfileContactMethods(_ value: ConnectionContactMethod)
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Method/addToProfileContactMethods(_%3A)/addToProfileContactMethods(_:)--##
	***public*** *instance method*
	No documentation
	```swift
	@NSManaged public func addToProfileContactMethods(_ values: NSOrderedSet)
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`
* ##--Method/removeFromProfileContactMethods(_%3A)/removeFromProfileContactMethods(_:)--##
	***public*** *instance method*
	No documentation
	```swift
	@NSManaged public func removeFromProfileContactMethods(_ values: NSOrderedSet)
	```
	*Found in:*

* `swaap/Models/ConnectionContact+CoreDataProperties.swift`



