## ProfileContactMethod

**internal** *struct*

```swift
struct ProfileContactMethod: Codable, Hashable
```

Represents a single contact method for a user



*Found in:*

* `swaap/Models/Contact Method Model/ProfileContactMethod.swift`


### Members



* ##--Property/id/id--##
	***internal*** *instance property*
	No documentation
	```swift
	let id: String?
	```

* ##--Property/value/value--##
	***internal*** *instance property*
	No documentation
	```swift
	let value: String
	```

* ##--Property/type/type--##
	***internal*** *instance property*
	No documentation
	```swift
	let type: ProfileFieldType
	```

* ##--Property/privacy/privacy--##
	***internal*** *instance property*
	No documentation
	```swift
	var privacy: ProfileFieldPrivacy
	```

* ##--Property/preferredContact/preferredContact--##
	***internal*** *instance property*
	No documentation
	```swift
	var preferredContact: Bool
	```

* ##--Property/infoNugget/infoNugget--##
	***internal*** *instance property*
	No documentation
	```swift
	var infoNugget: ProfileInfoNugget
	```

* ##--Method/init(id%3Avalue%3Atype%3Aprivacy%3ApreferredContact%3A)/init(id:value:type:privacy:preferredContact:)--##
	***internal*** *instance method*
	No documentation
	```swift
	init(id: String? = nil, value: String, type: ProfileFieldType, privacy: ProfileFieldPrivacy = .connected, preferredContact: Bool = false)
	```


