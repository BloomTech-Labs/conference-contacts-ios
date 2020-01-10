## BasicInfoView

**internal** *class*

```swift
class BasicInfoView: IBPreviewControl
```

No documentation



*Found in:*

* `swaap/Views/BasicInfoView.swift`


### Members



* ##--Property/contentView/contentView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private var contentView: UIView!
	```

* ##--Property/iconImageView/iconImageView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var iconImageView: UIImageView!
	```

* ##--Property/headerLabel/headerLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var headerLabel: UILabel!
	```

* ##--Property/valueLabel/valueLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var valueLabel: LabelPlaceholder!
	```

* ##--Property/containerView/containerView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var containerView: UIView!
	```

* ##--Property/containerViewHeightConstraint/containerViewHeightConstraint--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var containerViewHeightConstraint: NSLayoutConstraint!
	```

* ##--Property/icon/icon--##
	***internal*** *instance property*
	No documentation
	```swift
	var icon: UIImage?
	```

* ##--Property/headerText/headerText--##
	***internal*** *instance property*
	No documentation
	```swift
	var headerText: String
	```

* ##--Property/valueText/valueText--##
	***internal*** *instance property*
	No documentation
	```swift
	var valueText: String?
	```

* ##--Property/valuePlaceholder/valuePlaceholder--##
	***internal*** *instance property*
	No documentation
	```swift
	var valuePlaceholder: String?
	```

* ##--Property/headerTextFontSize/headerTextFontSize--##
	***internal*** *instance property*
	No documentation
	```swift
	var headerTextFontSize: CGFloat = 13
	```

* ##--Property/customSubview/customSubview--##
	***internal*** *instance property*
	No documentation
	```swift
	var customSubview: UIView?
	```

* ##--Property/customViewMaxHeight/customViewMaxHeight--##
	***internal*** *instance property*
	No documentation
	```swift
	var customViewMaxHeight: CGFloat?
	```

* ##--Method/init(frame%3A)/init(frame:)--##
	***internal*** *instance method*
	No documentation
	```swift
	override init(frame: CGRect)
	```

* ##--Method/init(coder%3A)/init(coder:)--##
	***internal*** *instance method*
	No documentation
	```swift
	required init?(coder aDecoder: NSCoder)
	```

* ##--Method/commonInit()/commonInit()--##
	***private*** *instance method*
	No documentation
	```swift
	private func commonInit()
	```

* ##--Method/updateCustomView(oldView%3A)/updateCustomView(oldView:)--##
	***private*** *instance method*
	No documentation
	```swift
	private func updateCustomView(oldView: UIView?)
	```

* ##--Method/updateViews()/updateViews()--##
	***private*** *instance method*
	No documentation
	```swift
	private func updateViews()
	```


