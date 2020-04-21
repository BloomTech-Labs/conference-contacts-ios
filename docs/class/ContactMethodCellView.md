## ContactMethodCellView

**internal** *class*

```swift
class ContactMethodCellView: UIView
```

No documentation



*Found in:*

* `swaap/Views/ContactMethodCellView.swift`


### Members



* ##--Property/contentView/contentView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var contentView: UIView!
	```

* ##--Property/cellView/cellView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var cellView: UIView!
	```

* ##--Property/starButton/starButton--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var starButton: UIButton!
	```

* ##--Property/socialButton/socialButton--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var socialButton: SocialButton!
	```

* ##--Property/valueLabel/valueLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var valueLabel: UILabel!
	```

* ##--Property/deleteButton/deleteButton--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var deleteButton: UIButton!
	```

* ##--Property/privacySettingLabel/privacySettingLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var privacySettingLabel: UILabel!
	```

* ##--Property/delegate/delegate--##
	***internal*** *instance property*
	No documentation
	```swift
	weak var delegate: ContactMethodCellViewDelegate?
	```

* ##--Property/mode/mode--##
	***internal*** *instance property*
	No documentation
	```swift
	let mode: Mode
	```

* ##--Enum/ContactMethodCellView.Mode/ContactMethodCellView.Mode--##
	***internal*** *enum*
	No documentation
	```swift
	enum Mode
	```

* ##--Property/contactMethod/contactMethod--##
	***internal*** *instance property*
	No documentation
	```swift
	var contactMethod: ProfileContactMethod
	```

* ##--Method/init(frame%3AcontactMethod%3Amode%3A)/init(frame:contactMethod:mode:)--##
	***internal*** *instance method*
	No documentation
	```swift
	init(frame: CGRect = CGRect(origin: .zero, size: CGSize(width: 375, height: 60)),
		 contactMethod: ProfileContactMethod,
		 mode: Mode)
	```

* ##--Method/init(frame%3A)/init(frame:)--##
	***internal*** *instance method*
	No documentation
	```swift
	no declaration
	```

* ##--Method/init(coder%3A)/init(coder:)--##
	***internal*** *instance method*
	No documentation
	```swift
	no declaration
	```

* ##--Method/commonInit()/commonInit()--##
	***private*** *instance method*
	No documentation
	```swift
	private func commonInit()
	```

* ##--Method/updateViews()/updateViews()--##
	***private*** *instance method*
	No documentation
	```swift
	private func updateViews()
	```

* ##--Method/starButtonTapped(_%3A)/starButtonTapped(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func starButtonTapped(_ sender: UIButton)
	```

* ##--Method/deleteButtonTapped(_%3A)/deleteButtonTapped(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func deleteButtonTapped(_ sender: UIButton)
	```

* ##--Method/cellButtonTapped(_%3A)/cellButtonTapped(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func cellButtonTapped(_ sender: UIButton)
	```

* ##--Method/longPressTriggered(_%3A)/longPressTriggered(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func longPressTriggered(_ sender: UILongPressGestureRecognizer)
	```

* ##--Method/actOnTaP()/actOnTaP()--##
	***internal*** *instance method*
	No documentation
	```swift
	func actOnTaP()
	```


