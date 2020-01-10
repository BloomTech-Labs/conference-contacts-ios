## SignUpViewController

**internal** *class*

```swift
class SignUpViewController: UIViewController
```

No documentation



*Found in:*

* `swaap/View Controllers/SignUpViewController.swift`


### Members



* ##--Property/emailForm/emailForm--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var emailForm: FormInputView!
	```

* ##--Property/passwordForm/passwordForm--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var passwordForm: FormInputView!
	```

* ##--Property/passwordConfirmForm/passwordConfirmForm--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var passwordConfirmForm: FormInputView!
	```

* ##--Property/signUpButton/signUpButton--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var signUpButton: ButtonHelper!
	```

* ##--Property/passwordStrengthLabel/passwordStrengthLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var passwordStrengthLabel: UILabel!
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

* ##--Method/signupTapped(_%3A)/signupTapped(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func signupTapped(_ sender: ButtonHelper)
	```

* ##--Method/textFieldChanged(_%3A)/textFieldChanged(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func textFieldChanged(_ sender: FormInputView)
	```

* ##--Method/emailFormDidFinish(_%3A)/emailFormDidFinish(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func emailFormDidFinish(_ sender: FormInputView)
	```

* ##--Method/passwordFormDidFinish(_%3A)/passwordFormDidFinish(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func passwordFormDidFinish(_ sender: FormInputView)
	```

* ##--Method/textFieldDidBeginEditing(_%3A)/textFieldDidBeginEditing(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func textFieldDidBeginEditing(_ sender: FormInputView)
	```

* ##--Method/passwordFieldDidChange(_%3A)/passwordFieldDidChange(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func passwordFieldDidChange(_ sender: FormInputView)
	```

* ##--Method/confirmPasswordFormDidFinish(_%3A)/confirmPasswordFormDidFinish(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func confirmPasswordFormDidFinish(_ sender: FormInputView)
	```

* ##--Method/updateSignUpButtonEnabled()/updateSignUpButtonEnabled()--##
	***private*** *instance method*
	No documentation
	```swift
	private func updateSignUpButtonEnabled()
	```

* ##--Method/updatePasswordStrengthLabel()/updatePasswordStrengthLabel()--##
	***private*** *instance method*
	No documentation
	```swift
	private func updatePasswordStrengthLabel()
	```

* ##--Method/checkEmail()/checkEmail()--##
	***private*** *instance method*
	No documentation
	```swift
	private func checkEmail() -> String?
	```

* ##--Method/checkPasswordStrength()/checkPasswordStrength()--##
	***private*** *instance method*
	No documentation
	```swift
	private func checkPasswordStrength() -> String?
	```

* ##--Method/checkPasswordMatch()/checkPasswordMatch()--##
	***private*** *instance method*
	No documentation
	```swift
	private func checkPasswordMatch() -> Bool
	```

* ##--Method/checkFormValidity()/checkFormValidity()--##
	***private*** *instance method*
	No documentation
	```swift
	private func checkFormValidity() -> (email: String, password: String)?
	```

### Extension: SignUpViewController

**internal** *extension*

```swift
extension SignUpViewController: RootAuthViewControllerDelegate
```

No documentation




* ##--Method/controllerWillScroll(_%3A)/controllerWillScroll(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func controllerWillScroll(_ controller: RootAuthViewController)
	```


