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
import NetworkHandler

class LogInViewController: UIViewController {

	// MARK: - Outlets
	@IBOutlet private weak var signupButton: UIButton!
	@IBOutlet private weak var mainStackView: UIStackView!
	@IBOutlet private weak var googleSigninButton: ButtonHelper!

	let appleAuthButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)

	// MARK: - Properties
	let authManager: AuthManager
	let profileController: ProfileController

	// MARK: - Lifecycle
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init coder not implemented")
	}

	init?(coder: NSCoder, authManager: AuthManager, profileController: ProfileController) {
		self.authManager = authManager
		self.profileController = profileController
		super.init(coder: coder)
	}

	override func viewDidLoad() {
        super.viewDidLoad()
		setupUI()
    }

	private func setupUI() {
		overrideUserInterfaceStyle = .light
	}

    // MARK: - Actions
	@IBAction func googleSignInTapped(_ sender: ButtonHelper) {
		authManager.showWebAuth(completion: { [weak self] error in
			guard let self = self else { return }
			if let error = error {
				self.showErrorAlert(error)
				return
			}
			self.initiateProfileFetch()
		})
	}

	@IBAction func signInTapped(_ sender: UIButton) {
		authManager.showWebAuth(completion: { [weak self] error in
			guard let self = self else { return }
			if let error = error {
				self.showErrorAlert(error)
				return
			}
			self.initiateProfileFetch()
		})
	}

	private func initiateProfileFetch() {
		profileController.fetchProfileFromServer { result in
			switch result {
			case .success:
				break
			case .failure(let error):
				NSLog("Error getting user: \(error)")

			}
		}
	}

	private func showErrorAlert(_ error: Error) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(error: error)
            self.present(alertVC, animated: true)
        }
	}

	@IBAction func logoutTapped(_ sender: ButtonHelper) {
		authManager.clearSession()
	}
}
