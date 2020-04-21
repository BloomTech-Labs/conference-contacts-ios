## ProfileQRCode

**internal** *struct*

```swift
struct ProfileQRCode: Codable, Hashable
```

Stores data for generating a QR code.



*Found in:*

* `swaap/Models/User Profile Model/ProfileQRCode.swift`


### Members



* ##--Property/id/id--##
	***internal*** *instance property*
	No documentation
	```swift
	let id: String
	```

* ##--Property/label/label--##
	***internal*** *instance property*
	No documentation
	```swift
	let label: String
	```

* ##--Property/scans/scans--##
	***internal*** *instance property*
	No documentation
	```swift
	let scans: Int
	```

* ##--Property/user/user--##
	***internal*** *instance property*
	No documentation
	```swift
	let user: UserProfile?
	```

* ##--Method/init(id%3Alabel%3Ascans%3Auser%3A)/init(id:label:scans:user:)--##
	***internal*** *instance method*
	No documentation
	```swift
	init(id: String, label: String, scans: Int, user: UserProfile? = nil)
	```


