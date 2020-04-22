## ContactPendingStatus

**internal** *enum*

```swift
enum ContactPendingStatus: Int16
```

Specifically used to determine if a contact is connected or pending, while differentiating between pending contacts that are both sent and received. Only used locally. Not to be confused with ContactConnectionStatus.



*Found in:*

* `swaap/Models/ConnectionContact+Convenience.swift`


### Members



* ##--Element/pendingSent/pendingSent--##
	***internal*** *enum element*
	No documentation
	```swift
	case pendingSent
	```

* ##--Element/pendingReceived/pendingReceived--##
	***internal*** *enum element*
	No documentation
	```swift
	case pendingReceived
	```

* ##--Element/connected/connected--##
	***internal*** *enum element*
	No documentation
	```swift
	case connected
	```

* ##--Method/init(with%3A)/init(with:)--##
	***internal*** *instance method*
	No documentation
	```swift
	init(with value: Int16)
	```


