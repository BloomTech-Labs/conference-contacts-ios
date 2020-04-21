## FloatingTextFieldView

**internal** *class*

```swift
class FloatingTextFieldView: IBPreviewView, UICollectionViewDelegate, UICollectionViewDataSource
```

No documentation



*Found in:*

* `swaap/Views/FloatingTextFieldView.swift`


### Members



* ##--Property/contentView/contentView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private var contentView: UIView!
	```

* ##--Property/textField/textField--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var textField: UITextField!
	```

* ##--Property/socialButton/socialButton--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var socialButton: SocialButton!
	```

* ##--Property/plusButton/plusButton--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var plusButton: UIButton!
	```

* ##--Property/socialButtonContainer/socialButtonContainer--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var socialButtonContainer: UIStackView!
	```

* ##--Property/horizontalSeparator/horizontalSeparator--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var horizontalSeparator: UIView!
	```

* ##--Property/aapstertSymbol/aapstertSymbol--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var aapstertSymbol: UILabel!
	```

* ##--Property/cancelButton/cancelButton--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var cancelButton: ButtonHelper!
	```

* ##--Property/saveButton/saveButton--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var saveButton: ButtonHelper!
	```

* ##--Property/collectionView/collectionView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var collectionView: UICollectionView!
	```

* ##--Property/socialType/socialType--##
	***internal*** *instance property*
	No documentation
	```swift
	var socialType: ProfileFieldType?
	```

* ##--Property/enableSaveButtonClosure/enableSaveButtonClosure--##
	***internal*** *instance property*
	No documentation
	```swift
	var enableSaveButtonClosure: EnableSaveButtonHandler?
	```

* ##--Alias/FloatingTextFieldView.EnableSaveButtonHandler/FloatingTextFieldView.EnableSaveButtonHandler--##
	***internal*** *typealias*
	No documentation
	```swift
	typealias EnableSaveButtonHandler = (ProfileFieldType?, String) -> Bool
	```

* ##--Property/delegate/delegate--##
	***internal*** *instance property*
	No documentation
	```swift
	weak var delegate: FloatingTextFieldViewDelegate?
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

* ##--Method/becomeFirstResponder()/becomeFirstResponder()--##
	***internal*** *instance method*
	No documentation
	```swift
	override func becomeFirstResponder() -> Bool
	```

* ##--Method/hideKeyboardAction()/hideKeyboardAction()--##
	***internal*** *instance method*
	No documentation
	```swift
	@objc func hideKeyboardAction()
	```

* ##--Method/formatTextField()/formatTextField()--##
	***private*** *instance method*
	No documentation
	```swift
	private func formatTextField()
	```

* ##--Property/dummyTextField/dummyTextField--##
	***internal*** *instance property*
	No documentation
	```swift
	lazy var dummyTextField: UITextField
	```

* ##--Method/changeKeyboard(type%3A)/changeKeyboard(type:)--##
	***private*** *instance method*
	No documentation
	```swift
	private func changeKeyboard(type: UIKeyboardType)
	```

* ##--Method/textFieldDidChange(_%3A)/textFieldDidChange(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func textFieldDidChange(_ sender: UITextField)
	```

* ##--Method/cancelTapped(_%3A)/cancelTapped(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func cancelTapped(_ sender: ButtonHelper)
	```

* ##--Method/saveTapped(_%3A)/saveTapped(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func saveTapped(_ sender: ButtonHelper)
	```

* ##--Method/addChangeSocialButton(_%3A)/addChangeSocialButton(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func addChangeSocialButton(_ sender: UIControl)
	```

* ##--Method/updateViews()/updateViews()--##
	***private*** *instance method*
	No documentation
	```swift
	private func updateViews()
	```

* ##--Method/makeFirstResponder(needsSocialTextField%3AplaceholderText%3AlabelText%3AcapitalizationType%3AsocialType%3A)/makeFirstResponder(needsSocialTextField:placeholderText:labelText:capitalizationType:socialType:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func makeFirstResponder(needsSocialTextField: Bool,
							placeholderText: String,
							labelText: String?,
							capitalizationType: UITextAutocapitalizationType,
							socialType: ProfileFieldType?)
	```

* ##--Method/hideAllSocialElements()/hideAllSocialElements()--##
	***private*** *instance method*
	No documentation
	```swift
	private func hideAllSocialElements()
	```

* ##--Method/shouldShowAtSymbol()/shouldShowAtSymbol()--##
	***private*** *instance method*
	No documentation
	```swift
	private func shouldShowAtSymbol()
	```

* ##--Method/showAtSymbol(_%3A)/showAtSymbol(_:)--##
	***private*** *instance method*
	No documentation
	```swift
	private func showAtSymbol(_ shouldShowSymbol: Bool)
	```

* ##--Method/shouldShowCollectionView(_%3A)/shouldShowCollectionView(_:)--##
	***private*** *instance method*
	No documentation
	```swift
	private func shouldShowCollectionView(_ show: Bool)
	```

* ##--Method/shouldEnableSaveButton()/shouldEnableSaveButton()--##
	***private*** *instance method*
	No documentation
	```swift
	@discardableResult private func shouldEnableSaveButton() -> Bool
	```

* ##--Method/saveText()/saveText()--##
	***private*** *instance method*
	No documentation
	```swift
	private func saveText()
	```

* ##--Method/numberOfSections(in%3A)/numberOfSections(in:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func numberOfSections(in collectionView: UICollectionView) -> Int
	```

* ##--Method/collectionView(_%3AnumberOfItemsInSection%3A)/collectionView(_:numberOfItemsInSection:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	```

* ##--Method/collectionView(_%3AcellForItemAt%3A)/collectionView(_:cellForItemAt:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	```

* ##--Method/didSelectSocialButton(_%3A)/didSelectSocialButton(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@objc func didSelectSocialButton(_ sender: SocialButton)
	```

### Extension: FloatingTextFieldView

**internal** *extension*

```swift
extension FloatingTextFieldView: UITextFieldDelegate
```

No documentation




* ##--Method/textFieldShouldReturn(_%3A)/textFieldShouldReturn(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	```


