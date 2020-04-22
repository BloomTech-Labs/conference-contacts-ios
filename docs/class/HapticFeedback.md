## HapticFeedback

**internal** *class*

```swift
class HapticFeedback
```

No documentation



*Found in:*

* `swaap/Helpers/HapticFeedback.swift`


### Members



* ##--Static/shared/shared--##
	***internal*** *static*
	No documentation
	```swift
	static let shared = HapticFeedback()
	```

* ##--Property/lightFeedback/lightFeedback--##
	***private*** *instance property*
	No documentation
	```swift
	private let lightFeedback = UIImpactFeedbackGenerator(style: .light)
	```

* ##--Property/mediumFeedback/mediumFeedback--##
	***private*** *instance property*
	No documentation
	```swift
	private let mediumFeedback = UIImpactFeedbackGenerator(style: .medium)
	```

* ##--Property/heavyFeedback/heavyFeedback--##
	***private*** *instance property*
	No documentation
	```swift
	private let heavyFeedback = UIImpactFeedbackGenerator(style: .heavy)
	```

* ##--Property/softFeedback/softFeedback--##
	***private*** *instance property*
	No documentation
	```swift
	private let softFeedback = UIImpactFeedbackGenerator(style: .soft)
	```

* ##--Property/rigidFeedback/rigidFeedback--##
	***private*** *instance property*
	No documentation
	```swift
	private let rigidFeedback = UIImpactFeedbackGenerator(style: .rigid)
	```

* ##--Property/selectionFeedback/selectionFeedback--##
	***private*** *instance property*
	No documentation
	```swift
	private let selectionFeedback = UISelectionFeedbackGenerator()
	```

* ##--Method/init()/init()--##
	***private*** *instance method*
	No documentation
	```swift
	private init()
	```

* ##--Static/produceLightFeedback()/produceLightFeedback()--##
	***internal*** *static*
	No documentation
	```swift
	static func produceLightFeedback()
	```

* ##--Static/produceMediumFeedback()/produceMediumFeedback()--##
	***internal*** *static*
	No documentation
	```swift
	static func produceMediumFeedback()
	```

* ##--Static/produceHeavyFeedback()/produceHeavyFeedback()--##
	***internal*** *static*
	No documentation
	```swift
	static func produceHeavyFeedback()
	```

* ##--Static/produceSoftFeedback()/produceSoftFeedback()--##
	***internal*** *static*
	No documentation
	```swift
	static func produceSoftFeedback()
	```

* ##--Static/produceRigidFeedback()/produceRigidFeedback()--##
	***internal*** *static*
	No documentation
	```swift
	static func produceRigidFeedback()
	```

* ##--Static/produceSelectionFeedback()/produceSelectionFeedback()--##
	***internal*** *static*
	No documentation
	```swift
	static func produceSelectionFeedback()
	```


