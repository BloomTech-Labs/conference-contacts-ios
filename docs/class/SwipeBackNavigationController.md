## SwipeBackNavigationController

**internal** *class*

```swift
class SwipeBackNavigationController: UINavigationController, AuthAccessor, ProfileAccessor, ContactsAccessor
```

The SwipeBackNavigationController is required to allow for swiping back when the navigation bar is hidden (normal
behavior is to disable the swipe gesture to pop the top ViewController on the stack when the navbar is hidden). We
also added the feature to automatically inject dependencies on ViewControllers added to the stack that conform to
their respective protocols regarding model controllers. However, you will need to somehow pass the instances in as well.

Most instances of SwipeBackNavigationController reside on the RootTabBarController and that is already taken care of,
but if you add any others that aren't directly parented by the RootTabBarController, you will be responsible for
providing the respective controllers



*Found in:*

* `swaap/View Controllers/SwipeBackNavigationController.swift`


### Members



* ##--Property/popRecognizer/popRecognizer--##
	***internal*** *instance property*
	No documentation
	```swift
	var popRecognizer: InteractivePopRecognizer?
	```

* ##--Property/authManager/authManager--##
	***internal*** *instance property*
	No documentation
	```swift
	var authManager: AuthManager?
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

* ##--Method/init(coder%3A)/init(coder:)--##
	***internal*** *instance method*
	No documentation
	```swift
	required init?(coder aDecoder: NSCoder)
	```

* ##--Method/init(coder%3AprofileController%3AauthManager%3A)/init(coder:profileController:authManager:)--##
	***internal*** *instance method*
	No documentation
	```swift
	convenience init?(coder decoder: NSCoder, profileController: ProfileController?, authManager: AuthManager? = nil)
	```

* ##--Method/viewDidLoad()/viewDidLoad()--##
	***internal*** *instance method*
	No documentation
	```swift
	override func viewDidLoad()
	```

* ##--Method/fixUINavigationBarHideAndUnhideWhenSwipingBackToPreviousUIViewControllerWhenPoppingTopViewControllerOnNavigationStack()/fixUINavigationBarHideAndUnhideWhenSwipingBackToPreviousUIViewControllerWhenPoppingTopViewControllerOnNavigationStack()--##
	***private*** *instance method*
	Teeehehe
	```swift
	private func fixUINavigationBarHideAndUnhideWhenSwipingBackToPreviousUIViewControllerWhenPoppingTopViewControllerOnNavigationStack()
	```

* ##--Method/distributeAuthAccessor()/distributeAuthAccessor()--##
	***private*** *instance method*
	No documentation
	```swift
	private func distributeAuthAccessor()
	```

* ##--Method/distributeProfileAccessor()/distributeProfileAccessor()--##
	***private*** *instance method*
	No documentation
	```swift
	private func distributeProfileAccessor()
	```

* ##--Method/distributeContactsAccessor()/distributeContactsAccessor()--##
	***private*** *instance method*
	No documentation
	```swift
	private func distributeContactsAccessor()
	```

### Extension: SwipeBackNavigationController

**internal** *extension*

```swift
extension SwipeBackNavigationController: UINavigationControllerDelegate
```

No documentation




* ##--Method/navigationController(_%3AwillShow%3Aanimated%3A)/navigationController(_:willShow:animated:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool)
	```


