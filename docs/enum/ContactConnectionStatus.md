## ContactConnectionStatus

**internal** *enum*

```swift
enum ContactConnectionStatus: String, Codable, Hashable, CaseIterable
```

Specifically used for encoding and decoding JSON for GraphQL. Not to be confused with ContactPendingStatus.



*Found in:*

* `swaap/Models/Connection Model/ContactConnectionStatus.swift`


### Members



* ##--Method/init(from%3A)/init(from:)--##
	***internal*** *instance method*
	No documentation
	```swift
	init(from decoder: Decoder) throws
	```

* ##--Method/encode(to%3A)/encode(to:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func encode(to encoder: Encoder) throws
	```

* ##--Element/pending/pending--##
	***internal*** *enum element*
	No documentation
	```swift
	case pending
	```

* ##--Element/connected/connected--##
	***internal*** *enum element*
	No documentation
	```swift
	case connected
	```

* ##--Element/blocked/blocked--##
	***internal*** *enum element*
	No documentation
	```swift
	case blocked
	```


