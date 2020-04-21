## InputTextFieldViewController

**internal** *class*

```swift
class InputTextFieldViewController: UIViewController, Storyboarded
```

Presented when the user needs to edit text on their profile. It's a clean way of getting around the whole textview
behind the keyboard issue.



*Found in:*

* `swaap/View Controllers/InputTextFieldViewController.swift`


### Members



* ##--Property/floatingTextFieldView/floatingTextFieldView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var floatingTextFieldView: FloatingTextFieldView!
	```

* ##--Property/floatingViewBottomAnchor/floatingViewBottomAnchor--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var floatingViewBottomAnchor: NSLayoutConstraint!
	```

* ##--Property/tapToDismissGesture/tapToDismissGesture--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private var tapToDismissGesture: UITapGestureRecognizer!
	```

* ##--Property/needsSocialTextField/needsSocialTextField--##
	***internal*** *instance property*
	No documentation
	```swift
	let needsSocialTextField: Bool
	```

* ##--Property/autoCapitalizationType/autoCapitalizationType--##
	***internal*** *instance property*
	No documentation
	```swift
	var autoCapitalizationType: UITextAutocapitalizationType = .sentences
	```

* ##--Property/placeholderStr/placeholderStr--##
	***internal*** *instance property*
	No documentation
	```swift
	var placeholderStr: String = "enter info"
	```

* ##--Property/labelText/labelText--##
	***internal*** *instance property*
	No documentation
	```swift
	var labelText: String?
	```

* ##--Property/socialType/socialType--##
	***internal*** *instance property*
	No documentation
	```swift
	var socialType: ProfileFieldType?
	```

* ##--Property/successfulCompletion/successfulCompletion--##
	***internal*** *instance property*
	No documentation
	```swift
	let successfulCompletion: ProfileInfoNuggetCompletion
	```

* ##--Property/enableSaveButtonHandler/enableSaveButtonHandler--##
	***private*** *instance property*
	No documentation
	```swift
	private let enableSaveButtonHandler: FloatingTextFieldView.EnableSaveButtonHandler
	```

* ##--Alias/InputTextFieldViewController.ProfileInfoNuggetCompletion/InputTextFieldViewController.ProfileInfoNuggetCompletion--##
	***internal*** *typealias*
	No documentation
	```swift
	typealias ProfileInfoNuggetCompletion = (ProfileInfoNugget) -> Void
	```

* ##--Method/init(coder%3AneedsSocialTextField%3AsuccessfulCompletion%3AenableSaveButtonHandler%3A)/init(coder:needsSocialTextField:successfulCompletion:enableSaveButtonHandler:)--##
	***internal*** *instance method*
	No documentation
	```swift
	init?(coder: NSCoder,
		  needsSocialTextField: Bool = true,
		  successfulCompletion: @escaping ProfileInfoNuggetCompletion,
		  enableSaveButtonHandler: @escaping FloatingTextFieldView.EnableSaveButtonHandler = { _, _ in true })
	```

* ##--Method/init(coder%3A)/init(coder:)--##
	***internal*** *instance method*
	No documentation
	```swift
	no declaration
	```

* ##--Method/viewDidLoad()/viewDidLoad()--##
	***internal*** *instance method*
	No documentation
	```swift
	override func viewDidLoad()
	```

* ##--Method/viewDidAppear(_%3A)/viewDidAppear(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	override func viewDidAppear(_ animated: Bool)
	```

* ##--Method/keyboardFrameWillChange(notification%3A)/keyboardFrameWillChange(notification:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@objc func keyboardFrameWillChange(notification: NSNotification)
	```

* ##--Method/tapToDismiss(_%3A)/tapToDismiss(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func tapToDismiss(_ sender: UITapGestureRecognizer)
	```

### Extension: InputTextFieldViewController

**internal** *extension*

```swift
extension InputTextFieldViewController: UIGestureRecognizerDelegate
```

No documentation




* ##--Method/gestureRecognizer(_%3AshouldReceive%3A)/gestureRecognizer(_:shouldReceive:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
	```

### Extension: InputTextFieldViewController

**internal** *extension*

```swift
extension InputTextFieldViewController: FloatingTextFieldViewDelegate
```

No documentation




* ##--Method/didFinishEditing(_%3AinfoNugget%3A)/didFinishEditing(_:infoNugget:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func didFinishEditing(_ view: FloatingTextFieldView, infoNugget: ProfileInfoNugget)
	```

* ##--Method/didCancelEditing(_%3A)/didCancelEditing(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func didCancelEditing(_ view: FloatingTextFieldView)
	```


