## ConnectViewController

**internal** *class*

```swift
class ConnectViewController: UIViewController, ProfileAccessor, ContactsAccessor
```

Originally we meant to have NFC to swap info when you swipe your card up. Definitely a good release canvas item.



*Found in:*

* `swaap/View Controllers/ConnectViewController.swift`


### Members



* ##--Property/connectLabel/connectLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var connectLabel: UILabel!
	```

* ##--Property/swaapLogo/swaapLogo--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var swaapLogo: UIImageView!
	```

* ##--Property/smallProfileCard/smallProfileCard--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var smallProfileCard: ProfileCardView!
	```

* ##--Property/buttonContainer/buttonContainer--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var buttonContainer: UIView!
	```

* ##--Property/qrCodeButton/qrCodeButton--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var qrCodeButton: UIButton!
	```

* ##--Property/scanQRButton/scanQRButton--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var scanQRButton: UIButton!
	```

* ##--Property/swipeUpLabelBottomConstraint/swipeUpLabelBottomConstraint--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var swipeUpLabelBottomConstraint: NSLayoutConstraint!
	```

* ##--Property/buttonContainerBottomConstraint/buttonContainerBottomConstraint--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var buttonContainerBottomConstraint: NSLayoutConstraint!
	```

* ##--Property/instructionsLabel/instructionsLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var instructionsLabel: UILabel!
	```

* ##--Property/profileController/profileController--##
	***internal*** *instance property*
	No documentation
	```swift
	var profileController: ProfileController?
	```

* ##--Property/contactsController/contactsController--##
	***internal*** *instance property*
	No documentation
	```swift
	var contactsController: ContactsController?
	```

* ##--Property/pushNotificationTimer/pushNotificationTimer--##
	***internal*** *instance property*
	'"push" notification timer - just refreshses frequently to give the appearance that there are push notifications
	to notifiy you when you get a request - should definitely get updated to use real push notifications
	```swift
	var pushNotificationTimer: Timer?
	```

* ##--Property/prefersStatusBarHidden/prefersStatusBarHidden--##
	***internal*** *instance property*
	No documentation
	```swift
	override var prefersStatusBarHidden: Bool
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

* ##--Method/viewDidDisappear(_%3A)/viewDidDisappear(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	override func viewDidDisappear(_ animated: Bool)
	```

* ##--Method/prepare(for%3Asender%3A)/prepare(for:sender:)--##
	***internal*** *instance method*
	No documentation
	```swift
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	```

* ##--Method/setupUI()/setupUI()--##
	***private*** *instance method*
	No documentation
	```swift
	private func setupUI()
	```

* ##--Method/updateProfileCard()/updateProfileCard()--##
	***private*** *instance method*
	No documentation
	```swift
	private func updateProfileCard()
	```


