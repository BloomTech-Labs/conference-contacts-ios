## ReleaseState

**internal** *enum*

```swift
enum ReleaseState: String
```

To be used in determining the current release state of the build. For example, if it's in debug or on testflight,
it should use the staging backend server, but if it's on the app store it should use the production server.



*Found in:*

* `swaap/Helpers/ReleaseState.swift`


### Members



* ##--Element/debug/debug--##
	***internal*** *enum element*
	No documentation
	```swift
	case debug
	```

* ##--Element/testFlight/testFlight--##
	***internal*** *enum element*
	No documentation
	```swift
	case testFlight
	```

* ##--Element/appStore/appStore--##
	***internal*** *enum element*
	No documentation
	```swift
	case appStore
	```

* ##--Static/isTestFlight/isTestFlight--##
	***private*** *static*
	No documentation
	```swift
	private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
	```

* ##--Static/current/current--##
	***internal*** *static*
	you may set this to return .appStore to test production environment variables. just be certain NOT to commit it though!
	```swift
	static var current: ReleaseState
	```


