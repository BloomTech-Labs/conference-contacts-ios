## InteractivePopRecognizer

**internal** *class*

```swift
class InteractivePopRecognizer: NSObject, UIGestureRecognizerDelegate
```

No documentation



*Found in:*

* `swaap/Helpers/InteractivePopRecognizer.swift`


### Members



* ##--Property/navigationController/navigationController--##
	***internal*** *instance property*
	No documentation
	```swift
	let navigationController: UINavigationController
	```

* ##--Method/init(controller%3A)/init(controller:)--##
	***internal*** *instance method*
	No documentation
	```swift
	init(controller: UINavigationController)
	```

* ##--Method/gestureRecognizerShouldBegin(_%3A)/gestureRecognizerShouldBegin(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
	```

* ##--Method/gestureRecognizer(_%3AshouldRecognizeSimultaneouslyWith%3A)/gestureRecognizer(_:shouldRecognizeSimultaneouslyWith:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
						   shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
	```


