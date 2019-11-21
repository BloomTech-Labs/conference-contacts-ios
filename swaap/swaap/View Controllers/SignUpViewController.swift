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
		updateSignUpButtonEnabled()
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
		[sender, emailForm, passwordForm, passwordConfirmForm].forEach { $0.resignFirstResponder() }
	}

	@IBAction func textFieldChanged(_ sender: FormInputView) {
		updateSignUpButtonEnabled()
	}

	@IBAction func emailFormDidFinish(_ sender: FormInputView) {
		sender.validationState = checkEmail() != nil ? .pass : .fail
	}

	@IBAction func passwordFormDidFinish(_ sender: FormInputView) {
		sender.validationState = checkPasswordStrength() != nil ? .pass : .fail
	}

	@IBAction func confirmPasswordFormDidFinish(_ sender: FormInputView) {
		sender.validationState = (checkPasswordStrength() != nil && checkPasswordMatch()) ? .pass : .fail
	}

	// MARK: - Form Validation
	private func updateSignUpButtonEnabled() {
		signUpButton.isEnabled = checkFormValidity() != nil
	}

	private func checkEmail() -> String? {
		(emailForm.text?.isEmail ?? false) ? emailForm.text : nil
	}

	private func checkPasswordStrength() -> String? {
		guard let password = passwordForm.text,
			password.hasAtLeastXCharacters(8),
			password.hasALowercaseCharacter,
			password.hasAnUppercaseCharacter,
			password.hasANumericalCharacter,
			password.hasASpecialCharacter else { return nil }
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
