## GradientView

**internal** *class*

```swift
class GradientView: UIView
```

No documentation



*Found in:*

* `swaap/Views/GradientView.swift`


### Members



* ##--Property/startColor/startColor--##
	***internal*** *instance property*
	No documentation
	```swift
	@IBInspectable var startColor: UIColor = .black
	```

* ##--Property/endColor/endColor--##
	***internal*** *instance property*
	No documentation
	```swift
	@IBInspectable var endColor: UIColor = .white
	```

* ##--Property/startPoint/startPoint--##
	***internal*** *instance property*
	No documentation
	```swift
	@IBInspectable var startPoint: CGPoint = .zero
	```

* ##--Property/endPoint/endPoint--##
	***internal*** *instance property*
	No documentation
	```swift
	@IBInspectable var endPoint: CGPoint = .init(x: 0, y: 1)
	```

* ##--Source.Lang.Swift.Decl.Var.Class/layerClass/layerClass--##
	***public*** *source.lang.swift.decl.var.class*
	No documentation
	```swift
	override public class var layerClass: AnyClass
	```

* ##--Property/gradientLayer/gradientLayer--##
	***internal*** *instance property*
	No documentation
	```swift
	var gradientLayer: CAGradientLayer
	```

* ##--Method/updatePoints()/updatePoints()--##
	***internal*** *instance method*
	No documentation
	```swift
	func updatePoints()
	```

* ##--Method/updateColors()/updateColors()--##
	***internal*** *instance method*
	No documentation
	```swift
	func updateColors()
	```

* ##--Method/layoutSubviews()/layoutSubviews()--##
	***public*** *instance method*
	No documentation
	```swift
	override public func layoutSubviews()
	```


