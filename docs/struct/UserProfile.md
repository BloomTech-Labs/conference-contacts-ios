## UserProfile

**internal** *struct*

```swift
struct UserProfile: Codable, Hashable
```

Used both for decoding JSON from the server and passing data around the app. Note that while the ProfileViewController
utilizes this for displaying both user and contact data, contacts are not cached on disk in this format. Instead,
they are cached as a CoreData class. Convenience methods are available to convert between them, but be aware that they are not lossless.



*Found in:*

* `swaap/Models/User Profile Model/UserProfile.swift`


### Members



* ##--Enum/UserProfile.CodingKeys/UserProfile.CodingKeys--##
	***internal*** *enum*
	No documentation
	```swift
	enum CodingKeys: String, CodingKey
	```

* ##--Property/id/id--##
	***internal*** *instance property*
	No documentation
	```swift
	let id: String
	```

* ##--Property/authID/authID--##
	***internal*** *instance property*
	No documentation
	```swift
	let authID: String?
	```

* ##--Property/name/name--##
	***internal*** *instance property*
	No documentation
	```swift
	var name: String
	```

* ##--Property/pictureString/pictureString--##
	***private*** *instance property*
	No documentation
	```swift
	private var pictureString: String?
	```

* ##--Property/birthdate/birthdate--##
	***internal*** *instance property*
	No documentation
	```swift
	var birthdate: String?
	```

* ##--Property/location/location--##
	***internal*** *instance property*
	No documentation
	```swift
	var location: String?
	```

* ##--Property/industry/industry--##
	***internal*** *instance property*
	No documentation
	```swift
	var industry: String?
	```

* ##--Property/jobTitle/jobTitle--##
	***internal*** *instance property*
	No documentation
	```swift
	var jobTitle: String?
	```

* ##--Property/tagline/tagline--##
	***internal*** *instance property*
	No documentation
	```swift
	var tagline: String?
	```

* ##--Property/bio/bio--##
	***internal*** *instance property*
	No documentation
	```swift
	var bio: String?
	```

* ##--Property/_profileContactMethods/_profileContactMethods--##
	***private*** *instance property*
	No documentation
	```swift
	private var _profileContactMethods: [ProfileContactMethod]?
	```

* ##--Property/profileContactMethods/profileContactMethods--##
	***internal*** *instance property*
	No documentation
	```swift
	var profileContactMethods: [ProfileContactMethod]
	```

* ##--Property/_qrCodes/_qrCodes--##
	***private*** *instance property*
	No documentation
	```swift
	private var _qrCodes: [ProfileQRCode]?
	```

* ##--Property/qrCodes/qrCodes--##
	***internal*** *instance property*
	No documentation
	```swift
	var qrCodes: [ProfileQRCode]
	```

* ##--Property/pictureURL/pictureURL--##
	***internal*** *instance property*
	No documentation
	```swift
	var pictureURL: URL
	```

* ##--Property/photoData/photoData--##
	***internal*** *instance property*
	No documentation
	```swift
	var photoData: Data?
	```

### Extension: UserProfile

**internal** *extension*

```swift
extension UserProfile
```

No documentation




* ##--Method/init(from%3A)/init(from:)--##
	***internal*** *instance method*
	No documentation
	```swift
	init?(from connectionContact: ConnectionContact)
	```

* ##--Static/zombie/zombie--##
	***internal*** *static*
	No documentation
	```swift
	static let zombie: UserProfile = UserProfile(id: "zombieID",
	```


