## RootAuthViewController

**internal** *class*

```swift
class RootAuthViewController: UIViewController
```

Parent ViewController to the LoginViewController and the SignUpViewController. The UIScrollView is here with both of
those embedded.
An instance of this is modally shown or dismissed by the RootTabBarController as it listens to the Notifications
occurring when user credentials are either populated or depopulated.



*Found in:*

* `swaap/View Controllers/RootAuthViewController.swift`


### Members



* ##--Property/profileController/profileController--##
	***internal*** *instance property*
	No documentation
	```swift
	let profileController: ProfileController
	```

* ##--Property/authManager/authManager--##
	***internal*** *instance property*
	No documentation
	```swift
	let authManager: AuthManager
	```

* ##--Property/scrollView/scrollView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var scrollView: UIScrollView!
	```

* ##--Property/stackView/stackView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var stackView: UIStackView!
	```

* ##--Property/loginView/loginView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var loginView: UIView!
	```

* ##--Property/chevron/chevron--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var chevron: ChevronView!
	```

* ##--Property/delegate/delegate--##
	***internal*** *instance property*
	No documentation
	```swift
	weak var delegate: RootAuthViewControllerDelegate?
	```

* ##--Method/init(coder%3AauthManager%3AprofileController%3A)/init(coder:authManager:profileController:)--##
	***internal*** *instance method*
	No documentation
	```swift
	init?(coder: NSCoder, authManager: AuthManager, profileController: ProfileController)
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

* ##--Method/showLoginVC(_%3A)/showLoginVC(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBSegueAction func showLoginVC(_ coder: NSCoder) -> LogInViewController?
	```

* ##--Method/showSignupVC(_%3A)/showSignupVC(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBSegueAction func showSignupVC(_ coder: NSCoder) -> SignUpViewController?
	```

* ##--Method/setupDelegates()/setupDelegates()--##
	***private*** *instance method*
	No documentation
	```swift
	private func setupDelegates()
	```

* ##--Method/updateChevron()/updateChevron()--##
	***private*** *instance method*
	No documentation
	```swift
	private func updateChevron()
	```

* ##--Method/chevronTapped(_%3A)/chevronTapped(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func chevronTapped(_ sender: UITapGestureRecognizer)
	```

### Extension: RootAuthViewController

**internal** *extension*

```swift
extension RootAuthViewController: UIScrollViewDelegate
```

No documentation




* ##--Method/scrollViewDidScroll(_%3A)/scrollViewDidScroll(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func scrollViewDidScroll(_ scrollView: UIScrollView)
	```

* ##--Method/scrollViewWillBeginDragging(_%3A)/scrollViewWillBeginDragging(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
	```


