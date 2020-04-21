## RootTabBarController

**internal** *class*

```swift
class RootTabBarController: UITabBarController
```

Obviously a tab bar controller, but this one is the root of the app. It houses the authManager, profileController,
and contactsController; Everything else that uses those access the instances that are instantiated here.



*Found in:*

* `swaap/View Controllers/RootTabBarController.swift`


### Members



* ##--Property/windowObserver/windowObserver--##
	***private*** *instance property*
	property observer (cannot present a view when its parent isn't part of the view hierarchy, so we need to watch
	for when the parent is in the hierarchy
	```swift
	private var windowObserver: NSKeyValueObservation?
	```

* ##--Property/authManager/authManager--##
	***internal*** *instance property*
	No documentation
	```swift
	let authManager: AuthManager
	```

* ##--Property/profileController/profileController--##
	***internal*** *instance property*
	No documentation
	```swift
	let profileController: ProfileController
	```

* ##--Property/contactsController/contactsController--##
	***internal*** *instance property*
	No documentation
	```swift
	let contactsController: ContactsController
	```

* ##--Property/rootAuthVC/rootAuthVC--##
	***internal*** *instance property*
	No documentation
	```swift
	lazy var rootAuthVC: RootAuthViewController
	```

* ##--Property/pendingContactsDelegate/pendingContactsDelegate--##
	***internal*** *instance property*
	No documentation
	```swift
	weak var pendingContactsDelegate: PendingContactsUpdateDelegate?
	```

* ##--Method/init(nibName%3Abundle%3A)/init(nibName:bundle:)--##
	***internal*** *instance method*
	No documentation
	```swift
	no declaration
	```

* ##--Method/init(coder%3A)/init(coder:)--##
	***internal*** *instance method*
	No documentation
	```swift
	required init?(coder: NSCoder)
	```

* ##--Property/viewControllers/viewControllers--##
	***internal*** *instance property*
	No documentation
	```swift
	override var viewControllers: [UIViewController]?
	```

* ##--Method/updateViewControllers()/updateViewControllers()--##
	***private*** *instance method*
	No documentation
	```swift
	private func updateViewControllers()
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

* ##--Method/showAuthViewController()/showAuthViewController()--##
	***private*** *instance method*
	No documentation
	```swift
	private func showAuthViewController()
	```

* ##--Method/dismissAuthViewController()/dismissAuthViewController()--##
	***private*** *instance method*
	No documentation
	```swift
	private func dismissAuthViewController()
	```


