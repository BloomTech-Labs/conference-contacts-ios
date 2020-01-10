## FormInputView

**internal** *class*

```swift
class FormInputView: IBPreviewControl
```

No documentation



*Found in:*

* `swaap/Views/FormInputView.swift`


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

* ##--Property/textField/textField--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var textField: UITextField!
	```

* ##--Property/bottomBorderView/bottomBorderView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var bottomBorderView: UIView!
	```

* ##--Property/validationContainer/validationContainer--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var validationContainer: UIView!
	```

* ##--Property/validationImage/validationImage--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var validationImage: UIImageView!
	```

* ##--Property/text/text--##
	***internal*** *instance property*
	No documentation
	```swift
	@IBInspectable var text: String?
	```

* ##--Property/placeholderText/placeholderText--##
	***internal*** *instance property*
	No documentation
	```swift
	@IBInspectable var placeholderText: String?
	```

* ##--Property/iconImage/iconImage--##
	***internal*** *instance property*
	No documentation
	```swift
	@IBInspectable var iconImage: UIImage?
	```

* ##--Property/keyboardType/keyboardType--##
	***internal*** *instance property*
	No documentation
	```swift
	var keyboardType: UIKeyboardType
	```

* ##--Property/contentType/contentType--##
	***internal*** *instance property*
	No documentation
	```swift
	var contentType: UITextContentType
	```

* ##--Property/isSecure/isSecure--##
	***internal*** *instance property*
	No documentation
	```swift
	@IBInspectable var isSecure: Bool
	```

* ##--Property/validationState/validationState--##
	***internal*** *instance property*
	No documentation
	```swift
	var validationState = ValidationState.hidden
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
	required init?(coder: NSCoder)
	```

* ##--Method/commonInit()/commonInit()--##
	***private*** *instance method*
	No documentation
	```swift
	private func commonInit()
	```

* ##--Method/updateValidationState()/updateValidationState()--##
	***private*** *instance method*
	No documentation
	```swift
	private func updateValidationState()
	```

* ##--Method/tintColorDidChange()/tintColorDidChange()--##
	***internal*** *instance method*
	No documentation
	```swift
	override func tintColorDidChange()
	```

* ##--Method/textFieldTouched(_%3A)/textFieldTouched(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func textFieldTouched(_ sender: UITextField)
	```

* ##--Method/textFieldFinished(_%3A)/textFieldFinished(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func textFieldFinished(_ sender: UITextField)
	```

* ##--Method/fadeBorderIn()/fadeBorderIn()--##
	***private*** *instance method*
	No documentation
	```swift
	private func fadeBorderIn()
	```

* ##--Method/fadeBorderOut()/fadeBorderOut()--##
	***private*** *instance method*
	No documentation
	```swift
	private func fadeBorderOut()
	```

### Extension: FormInputView

**internal** *extension*

```swift
extension FormInputView: UITextFieldDelegate
```

No documentation




* ##--Method/textFieldShouldReturn(_%3A)/textFieldShouldReturn(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	```


