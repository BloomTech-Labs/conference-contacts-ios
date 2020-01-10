## AuthManager

**internal** *class*

```swift
class AuthManager: NSObject
```

No documentation



*Found in:*

* `swaap/Model Controllers/AuthManager.swift`


### Members



* ##--Alias/AuthManager.AuthCallbackHandler/AuthManager.AuthCallbackHandler--##
	***internal*** *typealias*
	No documentation
	```swift
	typealias AuthCallbackHandler = (Error?) -> Void
	```

* ##--Property/credentialsManager/credentialsManager--##
	***internal*** *instance property*
	No documentation
	```swift
	let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
	```

* ##--Property/keychain/keychain--##
	***internal*** *instance property*
	No documentation
	```swift
	let keychain = A0SimpleKeychain()
	```

* ##--Property/credentials/credentials--##
	***internal*** *instance property*
	No documentation
	```swift
	private(set) var credentials: Credentials?
	```

* ##--Method/sendCredentialsNotification(oldValue%3AnewValue%3A)/sendCredentialsNotification(oldValue:newValue:)--##
	***private*** *instance method*
	No documentation
	```swift
	private func sendCredentialsNotification(oldValue: Credentials?, newValue: Credentials?)
	```

* ##--Property/credentialsCheckedFromLastSession/credentialsCheckedFromLastSession--##
	***internal*** *instance property*
	No documentation
	```swift
	private(set) var credentialsCheckedFromLastSession = false
	```

* ##--Property/credentialsLoading/credentialsLoading--##
	***internal*** *instance property*
	No documentation
	```swift
	let credentialsLoading = DispatchSemaphore(value: 0)
	```

* ##--Property/idClaims/idClaims--##
	***internal*** *instance property*
	No documentation
	```swift
	var idClaims: Auth0IDClaims?
	```

* ##--Method/init()/init()--##
	***internal*** *instance method*
	No documentation
	```swift
	override init()
	```

* ##--Method/init(testCredentials%3A)/init(testCredentials:)--##
	***internal*** *instance method*
	initializer used for testing
	```swift
	init(testCredentials: Credentials?)
	```

* ##--Method/showWebAuth(completion%3A)/showWebAuth(completion:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func showWebAuth(completion: @escaping AuthCallbackHandler)
	```

* ##--Property/signInWithAppleCallbackHandler/signInWithAppleCallbackHandler--##
	***private*** *instance property*
	No documentation
	```swift
	private var signInWithAppleCallbackHandler: AuthCallbackHandler?
	```

* ##--Method/signInWithApple(completion%3A)/signInWithApple(completion:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func signInWithApple(completion: @escaping AuthCallbackHandler)
	```

* ##--Method/tryRenewAuth(_%3A)/tryRenewAuth(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func tryRenewAuth(_ callback: @escaping (Credentials?, Error?) -> Void)
	```

* ##--Method/signUp(with%3Apassword%3Acompletion%3A)/signUp(with:password:completion:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func signUp(with email: String, password: String, completion: @escaping AuthCallbackHandler)
	```

* ##--Method/clearSession()/clearSession()--##
	***internal*** *instance method*
	No documentation
	```swift
	func clearSession()
	```

* ##--Method/networkAuthRequestCommon(for%3A)/networkAuthRequestCommon(for:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func networkAuthRequestCommon(for url: URL) -> NetworkRequest?
	```

* ##--Method/storeCredentials(appleID%3Acredentials%3A)/storeCredentials(appleID:credentials:)--##
	***private*** *instance method*
	No documentation
	```swift
	private func storeCredentials(appleID: String?, credentials: Credentials)
	```

* ##--Method/getIDClaims()/getIDClaims()--##
	***private*** *instance method*
	No documentation
	```swift
	private func getIDClaims() -> Auth0IDClaims?
	```

### Extension: AuthManager

**internal** *extension*

```swift
extension AuthManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding
```

No documentation




* ##--Method/presentationAnchor(for%3A)/presentationAnchor(for:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor
	```

* ##--Method/authorizationController(controller%3AdidCompleteWithError%3A)/authorizationController(controller:didCompleteWithError:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error)
	```

* ##--Enum/AuthManager.SignInWithAppleError/AuthManager.SignInWithAppleError--##
	***internal*** *enum*
	No documentation
	```swift
	enum SignInWithAppleError: Error
	```

* ##--Method/authorizationController(controller%3AdidCompleteWithAuthorization%3A)/authorizationController(controller:didCompleteWithAuthorization:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization)
	```


