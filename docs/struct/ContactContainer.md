## ContactContainer

**internal** *struct*

```swift
struct ContactContainer: Decodable
```

No documentation



*Found in:*

* `swaap/Models/Connection Model/Contact.swift`


### Members



* ##--Enum/ContactContainer.CodingKeys/ContactContainer.CodingKeys--##
	***internal*** *enum*
	No documentation
	```swift
	enum CodingKeys: String, CodingKey
	```

* ##--Property/connections/connections--##
	***internal*** *instance property*
	All CONNECTED status connections
	```swift
	let connections: [Contact]
	```

* ##--Property/sentConnections/sentConnections--##
	***internal*** *instance property*
	All connections user initiated, pending, connected, blocked
	```swift
	let sentConnections: [UserProfile]
	```

* ##--Property/receivedConnections/receivedConnections--##
	***internal*** *instance property*
	All connections user received, pending, connected, blocked
	```swift
	let receivedConnections: [UserProfile]
	```

* ##--Property/pendingReceivedConnections/pendingReceivedConnections--##
	***internal*** *instance property*
	All pending connections, sent or received
	```swift
	let pendingReceivedConnections: [Contact]
	```

* ##--Property/pendingSentConnections/pendingSentConnections--##
	***internal*** *instance property*
	No documentation
	```swift
	let pendingSentConnections: [Contact]
	```

* ##--Method/init(from%3A)/init(from:)--##
	***internal*** *instance method*
	No documentation
	```swift
	init(from decoder: Decoder) throws
	```


