//
//  SignUpViewController.swift
//  swaap
//
//  Created by Marlon Raskin on 11/14/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import AuthenticationServices

class SignUpViewController: UIViewController {

//	let appleAuthButton: ASAuthorizationAppleIDButton = {
//		let traitCollection = UITraitCollection()
//		switch traitCollection.userInterfaceStyle {
//		case .light:
//			return ASAuthorizationAppleIDButton(type: .default, style: .black)
//		case .dark:
//			return ASAuthorizationAppleIDButton(type: .default, style: .black)
//		default:
//			return ASAuthorizationAppleIDButton(type: .default, style: .black)
//		}
//	}()

	@IBOutlet private weak var nameTextField: UITextField!
	@IBOutlet private weak var nameLine: UIView!
	@IBOutlet private weak var emailTextField: UITextField!
	@IBOutlet private weak var emailLine: UIView!
	@IBOutlet private weak var passwordTextField: UITextField!
	@IBOutlet private weak var passwordLine: UIView!
	@IBOutlet private weak var passwordButton: UIButton!
	@IBOutlet private weak var signupButton: UIButton!
	@IBOutlet private weak var mainStackView: UIStackView!
	@IBOutlet private weak var appleAuthButtonLight: ASAuthorizationAppleIDButton!
	@IBOutlet private weak var appleAuthButtonDark: ASAuthorizationAppleIDButton!

	override func viewDidLoad() {
        super.viewDidLoad()
		[appleAuthButtonDark, appleAuthButtonLight].forEach { $0.addTarget(self, action: #selector(handleSignInWithAppleIDButtonTap), for: .touchUpInside) }
		performExistingAccountSetupFlows()
		setupUI()
    }

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		appleAuthButtonLight.overrideUserInterfaceStyle = .light
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

	private func configureAppleAuthButtons() {


	}

	@objc private func handleSignInWithAppleIDButtonTap(_ sender: ASAuthorizationAppleIDButton) {
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
		[nameTextField, emailTextField, passwordTextField].forEach { $0?.delegate = self }
		[nameLine, emailLine, passwordLine, passwordButton].forEach { $0?.alpha = 0 }
		signupButton.layer.cornerRadius = 8
		signupButton.layer.cornerCurve = .continuous
		signupButton.backgroundColor = UIColor(red: 0.40, green: 0.45, blue: 0.88, alpha: 1.00)
		appleAuthButtonLight.cornerRadius = 8
		appleAuthButtonLight.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
	}

}

extension SignUpViewController: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField == nameTextField {
			UIView.animate(withDuration: 0.5) {
				self.nameLine.alpha = 1
			}
		} else if textField == emailTextField {
			UIView.animate(withDuration: 0.5) {
				self.emailLine.alpha = 1
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
		} else if textField == emailTextField {
			UIView.animate(withDuration: 0.5) {
				self.emailLine.alpha = 0
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

extension SignUpViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
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
