//
//  SignUpViewController.swift
//  swaap
//
//  Created by Marlon Raskin on 11/14/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import AuthenticationServices
import Auth0
import SimpleKeychain

class LogInViewController: UIViewController {

	let appleAuthButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)

	// MARK: - Outlets
	@IBOutlet private weak var signupButton: UIButton!
	@IBOutlet private weak var usernameForm: FormInputView!
	@IBOutlet private weak var passwordForm: FormInputView!
	@IBOutlet private weak var mainStackView: UIStackView!
	@IBOutlet private weak var appleSigninContainer: UIView!
	@IBOutlet private weak var googleSigninButton: ButtonHelper!


	// MARK: - Properties
	let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
	let keychain = A0SimpleKeychain()

	var credentials: Credentials?

	// MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
		configureAppleAuthButton()
		setupUI()
		tryRenewAuth { credentials, error in
			if let error = error {
				NSLog("Unable to renew authorization: \(error)")
				return
			}
			DispatchQueue.main.async {
				guard let credentials = credentials else {
					print("Failed restoring credentials")
					return
				}
				print("restored saved credentials: \(credentials)")
			}
		}
    }

	private func setupUI() {
		overrideUserInterfaceStyle = .light
		usernameForm.contentType = .username
		passwordForm.contentType = .password
	}

	private func configureAppleAuthButton() {
		appleSigninContainer.addSubview(appleAuthButton)
		appleSigninContainer.backgroundColor = .clear
		appleAuthButton.translatesAutoresizingMaskIntoConstraints = false

		appleAuthButton.topAnchor.constraint(equalTo: appleSigninContainer.topAnchor).isActive = true
		appleAuthButton.bottomAnchor.constraint(equalTo: appleSigninContainer.bottomAnchor).isActive = true
		appleAuthButton.leadingAnchor.constraint(equalTo: appleSigninContainer.leadingAnchor).isActive = true
		appleAuthButton.trailingAnchor.constraint(equalTo: appleSigninContainer.trailingAnchor).isActive = true

		[appleAuthButton].forEach { $0.addTarget(self, action: #selector(handleSignInWithAppleIDButtonTap), for: .touchUpInside) }
	}


	func tryRenewAuth(_ callback: @escaping (Credentials?, Error?) -> Void) {
		let provider = ASAuthorizationAppleIDProvider()

		guard let userID = keychain.string(forKey: "userID") else {
			return callback(nil, nil)
		}

		provider.getCredentialState(forUserID: userID) { state, error in
			switch state {
			case .authorized:
				self.credentialsManager.credentials { error, credentials in
					guard error == nil, let credentials = credentials else {
						return callback(nil, error)
					}
					self.credentials = credentials
					callback(credentials, nil)
					print("Credentials state is Authorized: \(credentials)")
				}
			default:
				self.keychain.deleteEntry(forKey: "userID")
				_ = self.credentialsManager.clear()
				print("Credential state is unauthorized")
				callback(nil, error)
			}
		}
	}

	// MARK: - IBActions
	@objc private func handleSignInWithAppleIDButtonTap(_ sender: ASAuthorizationAppleIDButton?) {
		let appleIDProvider = ASAuthorizationAppleIDProvider()
		let request = appleIDProvider.createRequest()
		request.requestedScopes = [.email, .fullName]

		let authController = ASAuthorizationController(authorizationRequests: [request])
		authController.delegate = self
		authController.presentationContextProvider = self
		authController.performRequests()
	}

	@IBAction func googleSignInTapped(_ sender: ButtonHelper) {
		showWebAuth()
	}

	@IBAction func signInTapped(_ sender: UIButton) {
		showWebAuth()
		// Manual sign In/ Sign Up goes here
		// apparently this won't work unless an unsafe change is made online - just showing the web auth instead
//		guard let username = usernameForm.text, !username.isEmpty,
//			let password = passwordForm.text, !password.isEmpty else { return }

//		Auth0.authentication().login(usernameOrEmail: username,
//									 password: password,
//									 realm: "Username-Password-Authentication",
//									 audience: "https://api.swaap.co",
//									 scope: "openid profile",
//									 parameters: nil).start { result in
//			switch result {
//			case .failure(let error):
//				NSLog("Error: \(error)")
//			case .success(let credentials):
//				NSLog("Credentials: \(credentials)")
//			}
//		}
	}

	@IBAction func logoutTapped(_ sender: ButtonHelper) {
		Auth0.webAuth().clearSession(federated: false) { success in
			print("Successful logout: \(success)")
		}
	}


	private func showWebAuth() {
		Auth0.webAuth().scope("openid profile").audience("https://api.swaap.co/").start { result in
			switch result {
			case .failure(let error):
				NSLog("Error: \(error)")
			case .success(let credentials):
				NSLog("Credentials: \(credentials)")
			}
		}
	}
}


// MARK: - Sign in with Apple Delegate
extension LogInViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
	func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//		let authFailureAlert = UIAlertController(title: "Authorization Failed", message: nil, preferredStyle: .alert)
//		authFailureAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//		present(authFailureAlert, animated: true, completion: nil)
		NSLog("Authorization failed: \(error)")
	}

	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
			let userID = appleIDCredential.user
			if let userFirstName = appleIDCredential.fullName?.givenName,
				let userLastName = appleIDCredential.fullName?.familyName,
				let userEmail = appleIDCredential.email {
				print("ID: \(userID), First Name: \(userFirstName), Last name: \(userLastName), Email: \(userEmail)")
			}

			guard let authCodeData = appleIDCredential.authorizationCode, let authCode = String(data: authCodeData, encoding: .utf8) else {
				NSLog("Problem with Auth Code: \(appleIDCredential.authorizationCode as Any)")
				return
			}

			Auth0.authentication().tokenExchange(withAppleAuthorizationCode: authCode).start { result in
				switch result {
				case .success(let credentials):
					print("Auth0 success: \(credentials)")
					self.keychain.setString(appleIDCredential.user, forKey: "userID")
					self.credentials = credentials
					_ = self.credentialsManager.store(credentials: credentials)
				case .failure(let error):
					NSLog("Exchange failed: \(error)")
				}
			}
		}
	}


	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		guard let window = view.window else { fatalError("No window to attach to") }
		return window
	}
}
