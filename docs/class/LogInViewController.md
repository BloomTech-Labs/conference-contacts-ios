## LogInViewController

**internal** *class*

```swift
class LogInViewController: UIViewController
```

No documentation



*Found in:*

* `swaap/View Controllers/LogInViewController.swift`


### Members



* ##--Property/signupButton/signupButton--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var signupButton: UIButton!
	```

* ##--Property/mainStackView/mainStackView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var mainStackView: UIStackView!
	```

* ##--Property/appleSigninContainer/appleSigninContainer--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var appleSigninContainer: UIView!
	```

* ##--Property/googleSigninButton/googleSigninButton--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var googleSigninButton: ButtonHelper!
	```

* ##--Property/appleAuthButton/appleAuthButton--##
	***internal*** *instance property*
	No documentation
	```swift
	let appleAuthButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
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

* ##--Method/init(coder%3A)/init(coder:)--##
	***internal*** *instance method*
	No documentation
	```swift
	no declaration
	```

* ##--Method/init(coder%3AauthManager%3AprofileController%3A)/init(coder:authManager:profileController:)--##
	***internal*** *instance method*
	No documentation
	```swift
	init?(coder: NSCoder, authManager: AuthManager, profileController: ProfileController)
	```

* ##--Method/viewDidLoad()/viewDidLoad()--##
	***internal*** *instance method*
	No documentation
	```swift
	override func viewDidLoad()
	```

* ##--Method/setupUI()/setupUI()--##
	***private*** *instance method*
	No documentation
	```swift
	private func setupUI()
	```

* ##--Method/configureAppleAuthButton()/configureAppleAuthButton()--##
	***private*** *instance method*
	No documentation
	```swift
	private func configureAppleAuthButton()
	```

* ##--Method/handleSignInWithAppleIDButtonTap(_%3A)/handleSignInWithAppleIDButtonTap(_:)--##
	***private*** *instance method*
	No documentation
	```swift
	@objc private func handleSignInWithAppleIDButtonTap(_ sender: ASAuthorizationAppleIDButton?)
	```

* ##--Method/googleSignInTapped(_%3A)/googleSignInTapped(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func googleSignInTapped(_ sender: ButtonHelper)
	```

* ##--Method/signInTapped(_%3A)/signInTapped(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func signInTapped(_ sender: UIButton)
	```

* ##--Method/initiateProfileFetch()/initiateProfileFetch()--##
	***private*** *instance method*
	No documentation
	```swift
	private func initiateProfileFetch()
	```

* ##--Method/showErrorAlert(_%3A)/showErrorAlert(_:)--##
	***private*** *instance method*
	No documentation
	```swift
	private func showErrorAlert(_ error: Error)
	```

* ##--Method/logoutTapped(_%3A)/logoutTapped(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func logoutTapped(_ sender: ButtonHelper)
	```


