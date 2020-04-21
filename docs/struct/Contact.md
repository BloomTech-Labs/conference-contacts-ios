## Contact

**internal** *struct*

```swift
struct Contact: Codable, Hashable
```

Currently used ephemerally. JSON arrives in this form, its data is cached in CoreData, then the instances are discarded.



*Found in:*

* `swaap/Models/Connection Model/Contact.swift`


### Members



* ##--Property/id/id--##
	***internal*** *instance property*
	No documentation
	```swift
	let id: String
	```

* ##--Property/sender/sender--##
	***internal*** *instance property*
	No documentation
	```swift
	let sender: UserProfile?
	```

* ##--Property/receiver/receiver--##
	***internal*** *instance property*
	No documentation
	```swift
	let receiver: UserProfile?
	```

* ##--Property/status/status--##
	***internal*** *instance property*
	No documentation
	```swift
	let status: ContactConnectionStatus
	```

* ##--Property/connectedUser/connectedUser--##
	***internal*** *instance property*
	No documentation
	```swift
	var connectedUser: UserProfile
	```

* ##--Property/senderLat/senderLat--##
	***internal*** *instance property*
	No documentation
	```swift
	let senderLat: Float?
	```

* ##--Property/senderLon/senderLon--##
	***internal*** *instance property*
	No documentation
	```swift
	let senderLon: Float?
	```

* ##--Property/receiverLat/receiverLat--##
	***internal*** *instance property*
	No documentation
	```swift
	let receiverLat: Float?
	```

* ##--Property/receiverLon/receiverLon--##
	***internal*** *instance property*
	No documentation
	```swift
	let receiverLon: Float?
	```


