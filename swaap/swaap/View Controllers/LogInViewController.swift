//
//  SignUpViewController.swift
//  swaap
//
//  Created by Marlon Raskin on 11/14/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import AuthenticationServices

class LogInViewController: UIViewController {

	let appleAuthButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)

	// MARK: - Outlets
	@IBOutlet private weak var nameTextField: UITextField!
	@IBOutlet private weak var nameLine: UIView!
	@IBOutlet private weak var passwordTextField: UITextField!
	@IBOutlet private weak var passwordLine: UIView!
	@IBOutlet private weak var passwordButton: UIButton!
	@IBOutlet private weak var signupButton: UIButton!
	@IBOutlet private weak var mainStackView: UIStackView!
	@IBOutlet private weak var appleSigninContainer: UIView!
	@IBOutlet private weak var googleSigninButton: ButtonHelper!

	// MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
		configureAppleAuthButton()
		performExistingAccountSetupFlows()
		setupUI()
    }

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
	}

	@IBAction func signUpTapped(_ sender: UIButton) {
		// Manual sign In/ Sign Up goes here
	}

	private func animateTextFieldLines(textField: UITextField, line: UIView) {
		if textField.becomeFirstResponder() {
			UIView.animate(withDuration: 0.3) {
				line.isHidden = false
			}
		} else if textField.resignFirstResponder() {
			UIView.animate(withDuration: 0.3) {
				line.isHidden = true
			}
		}
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

	private func performExistingAccountSetupFlows() {
		// Prepare requests for both Apple ID  and password providers
		let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]

		// Create an authorization controller with the given requests
		let authController = ASAuthorizationController(authorizationRequests: requests)
		authController.delegate = self
		authController.presentationContextProvider = self
		authController.performRequests()
	}

	private func setupUI() {
		[nameTextField, passwordTextField].forEach { $0?.delegate = self }
		[nameLine, passwordLine, passwordButton].forEach { $0?.alpha = 0 }
	}

}

// MARK: - TextFieldDelegate
extension LogInViewController: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField == nameTextField {
			UIView.animate(withDuration: 0.5) {
				self.nameLine.alpha = 1
			}
		} else {
			UIView.animate(withDuration: 0.5) {
				self.passwordLine.alpha = 1
				self.passwordButton.alpha = 1
			}
		}
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField == nameTextField {
			UIView.animate(withDuration: 0.5) {
				self.nameLine.alpha = 0
			}
		} else {
			UIView.animate(withDuration: 0.5) {
				self.passwordLine.alpha = 0
				self.passwordButton.alpha = 0
			}
		}
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
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

		} else if let passwordCredential = authorization.credential as? ASPasswordCredential {
			// Sign in using an existing iCloud Keychain credential.
			let username = passwordCredential.user
			let password = passwordCredential.password

			print("Username: \(username), Password: \(password)")

			// Navigate to other View Controller
		}
	}


	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		return self.view.window!
	}
}
