//
//  SignUpViewController.swift
//  swaap
//
//  Created by Michael Redig on 11/19/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import Auth0

class SignUpViewController: UIViewController {
	@IBOutlet private weak var usernameForm: FormInputView!
	@IBOutlet private weak var emailForm: FormInputView!
	@IBOutlet private weak var passwordForm: FormInputView!
	@IBOutlet private weak var passwordConfirmForm: FormInputView!
	@IBOutlet private weak var signUpButton: ButtonHelper!


	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}

	private func setupUI() {
		overrideUserInterfaceStyle = .light
		usernameForm.contentType = .username
		emailForm.contentType = .emailAddress
		emailForm.keyboardType = .emailAddress
		passwordForm.contentType = .newPassword
		passwordConfirmForm.contentType = .newPassword
//		signUpButton.isEnabled = false
	}

	@IBAction func signupTapped(_ sender: ButtonHelper) {
		guard let (email, password) = checkFormValidity() else { return }
		Auth0.authentication()
			.createUser(email: email,
						password: password,
						connection: "Username-Password-Authentication",
						userMetadata: ["first_name": "First", "last_name": "Last"])
			.start { result in
				switch result {
				case .success(let user):
					print("User Signed up: \(user)")
				case .failure(let error):
					print("Failed with \(error)")
				}
		}
	}

	private func checkEmail() -> String? {
		(emailForm.text?.isEmail ?? false) ? emailForm.text : nil
	}

	private func checkPasswordStrength() -> String? {
		guard let password = passwordForm.text, password.count >= 8 else { return nil }
		return password
	}

	private func checkPasswordMatch() -> Bool {
		passwordForm.text == passwordConfirmForm.text
	}

	private func checkFormValidity() -> (email: String, password: String)? {
		guard let email = checkEmail(), let password = checkPasswordStrength(), checkPasswordMatch() else { return nil }
		signUpButton.isEnabled = true
		return (email, password)
	}
}
