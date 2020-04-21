## CGPoint

**open** *extension*

```swift
no declaration
```

The following are extensions on the CGPoint Type.



*Found in:*

* `swaap`


### Extension: CGPoint

**internal** *extension*

```swift
extension CGPoint
```

No documentation




* ##--Static/+(_%3A_%3A)/+(_:_:)--##
	***internal*** *static*
	No documentation
	```swift
	static func + (lhs: CGPoint, rhs: CGVector) -> CGPoint
	```
	*Found in:*

* `swaap/Helpers/VectorExtensions.swift`
* ##--Static/*(_%3A_%3A)/*(_:_:)--##
	***internal*** *static*
	No documentation
	```swift
	static func * (lhs: CGPoint, rhs: CGPoint) -> CGPoint
	```
	*Found in:*

* `swaap/Helpers/VectorExtensions.swift`
* ##--Method/distance(to%3A)/distance(to:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func distance(to point: CGPoint) -> CGFloat
	```
	*Found in:*

* `swaap/Helpers/VectorExtensions.swift`
* ##--Method/distance(to%3AisWithin%3A)/distance(to:isWithin:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func distance(to point: CGPoint, isWithin value: CGFloat) -> Bool
	```
	*Found in:*

* `swaap/Helpers/VectorExtensions.swift`
* ##--Method/stepped(toward%3Ainterval%3Aspeed%3A)/stepped(toward:interval:speed:)--##
	***internal*** *instance method*
	returns a point in the direction of the `toward` CGPoint, iterated at a speed of `speed` points per second. `interval`
	is the duration of time since the last frame was updated
	```swift
	func stepped(toward destination: CGPoint, interval: TimeInterval, speed: CGFloat) -> CGPoint
	```
	*Found in:*

* `swaap/Helpers/VectorExtensions.swift`
* ##--Method/step(toward%3Ainterval%3Aspeed%3A)/step(toward:interval:speed:)--##
	***internal*** *instance method*
	See `stepped`, just mutates self with the result
	```swift
	mutating func step(toward destination: CGPoint, interval: TimeInterval, speed: CGFloat)
	```
	*Found in:*

* `swaap/Helpers/VectorExtensions.swift`
* ##--Property/vector/vector--##
	***internal*** *instance property*
	No documentation
	```swift
	var vector: CGVector
	```
	*Found in:*

* `swaap/Helpers/VectorExtensions.swift`
* ##--Method/vector(facing%3Anormalized%3A)/vector(facing:normalized:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func vector(facing point: CGPoint, normalized normalize: Bool = true) -> CGVector
	```
	*Found in:*

* `swaap/Helpers/VectorExtensions.swift`


### Extension: CGPoint

**internal** *extension*

```swift
extension CGPoint
```

No documentation




* ##--Method/convertFromNormalized(to%3A)/convertFromNormalized(to:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func convertFromNormalized(to size: CGSize) -> CGPoint
	```
	*Found in:*

* `swaap/Helpers/HandyExtensions.swift`
* ##--Method/convertToNormalized(in%3A)/convertToNormalized(in:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func convertToNormalized(in size: CGSize) -> CGPoint
	```
	*Found in:*

* `swaap/Helpers/HandyExtensions.swift`
* ##--Method/distanceTo(pointB%3A)/distanceTo(pointB:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func distanceTo(pointB: CGPoint) -> CGFloat
	```
	*Found in:*

* `swaap/Helpers/HandyExtensions.swift`



