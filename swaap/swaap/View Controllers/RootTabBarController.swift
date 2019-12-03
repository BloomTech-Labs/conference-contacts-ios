//
//  RootTabBarController.swift
//  swaap
//
//  Created by Michael Redig on 11/12/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {
	let authManager = AuthManager()

	/// property observer (cannot present a view when its parent isn't part of the view hierarchy, so we need to watch
	/// for when the parent is in the hierarchy
	private var windowObserver: NSKeyValueObservation?
	private var credentialObserver: NSObjectProtocol?

	let contactsController = ContactsController()
	var rootAuthVC: RootAuthViewController?

	override func viewDidLoad() {
		super.viewDidLoad()
		credentialObserver = NotificationCenter.default.addObserver(forName: .swaapCredentialsChanged, object: nil, queue: nil) { [weak self] _ in
			self?.runAuthCoordinator()
		}

		// weird double optional BS
		guard let windowOpt = UIApplication.shared.delegate?.window else { return }
		guard let window = windowOpt else { return }
		windowObserver = window.observe(\UIWindow.rootViewController, changeHandler: { window, _ in
			if window.rootViewController === self {
				self.runAuthCoordinator()
			}
		})
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		runAuthCoordinator()
	}

	private func runAuthCoordinator() {
		if !authManager.credentialsCheckedFromLastSession {
			authManager.credentialsLoading.wait()
		}
		// check if user is logged in, only run if logged out:
		if authManager.credentials == nil {
			// check to confirm that theres either no presented VC or if there is, it's not the auth screen (prevent multiple auth screen layers)
			guard presentedViewController == nil ||
				(presentedViewController != nil && presentedViewController != rootAuthVC)
				else { return }

			let storyboard = UIStoryboard(name: "Login", bundle: nil)

			let rootAuthVC = storyboard.instantiateViewController(identifier: "RootAuthViewController") { coder in
				RootAuthViewController(coder: coder, authManager: self.authManager)
			}
			self.rootAuthVC = rootAuthVC
			rootAuthVC.modalPresentationStyle = .fullScreen
			self.present(rootAuthVC, animated: true, completion: nil)
		}
	}
}
