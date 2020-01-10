## GQMutation

**internal** *struct*

```swift
struct GQMutation
```

No documentation



*Found in:*

* `swaap/Models/GQuery.swift`


### Members



* ##--Property/query/query--##
	***internal*** *instance property*
	No documentation
	```swift
	let query: String
	```

* ##--Property/variables/variables--##
	***internal*** *instance property*
	No documentation
	```swift
	let variables: [String: Any]?
	```

* ##--Method/init(query%3Avariables%3A)/init(query:variables:)--##
	***internal*** *instance method*
	No documentation
	```swift
	init(query: String, variables: [String: Any]? = nil)
	```

* ##--Method/jsonData(_%3A)/jsonData(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func jsonData(_ prettyPrinted: Bool = false) throws -> Data
	```


