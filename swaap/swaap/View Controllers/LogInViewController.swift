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

class LogInViewController: UIViewController, AuthAccessor {

	// MARK: - Outlets
	@IBOutlet private weak var signupButton: UIButton!
	@IBOutlet private weak var mainStackView: UIStackView!
	@IBOutlet private weak var appleSigninContainer: UIView!
	@IBOutlet private weak var googleSigninButton: ButtonHelper!

	let appleAuthButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)

	// MARK: - Properties
	var authManager: AuthManager?

	// MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
		configureAppleAuthButton()
		setupUI()
    }

	private func setupUI() {
		overrideUserInterfaceStyle = .light
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
		authManager?.signInWithApple(completion: { error in
			if let error = error {
				NSLog("Show an alert with this error, stupid programmer: \(error)")
			}
		})
	}

	@IBAction func googleSignInTapped(_ sender: ButtonHelper) {
		authManager?.showWebAuth(completion: { error in
			if let error = error {
				NSLog("Show an alert with this error, stupid programmer: \(error)")
			}
		})
	}

	@IBAction func signInTapped(_ sender: UIButton) {
		authManager?.showWebAuth(completion: { error in
			if let error = error {
				NSLog("Show an alert with this error, stupid programmer: \(error)")
			}
		})
	}

	@IBAction func logoutTapped(_ sender: ButtonHelper) {
		authManager?.clearSession()
	}
}
