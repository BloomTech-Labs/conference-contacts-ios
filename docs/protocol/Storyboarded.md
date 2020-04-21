## Storyboarded

**internal** *protocol*

```swift
protocol Storyboarded
```

No documentation



*Found in:*

* `swaap/Helpers/Storyboarded.swift`


### Members



* ##--Static/instantiate(storyboardName%3Awith%3A)/instantiate(storyboardName:with:)--##
	***internal*** *static*
	No documentation
	```swift
	static func instantiate(storyboardName name: String, with customInitializer: ((NSCoder) -> UIViewController?)?) -> Self
	```

### Extension: Storyboarded

**internal** *extension*

```swift
extension Storyboarded where Self: UIViewController
```

No documentation




* ##--Static/instantiate(storyboardName%3Awith%3A)/instantiate(storyboardName:with:)--##
	***internal*** *static*
	No documentation
	```swift
	static func instantiate(storyboardName name: String = "Main", with customInitializer: ((NSCoder) -> UIViewController?)? = nil) -> Self
	```


