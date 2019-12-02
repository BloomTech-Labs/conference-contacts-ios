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
	// top level coordinators go here - they will be passed in as arguments to the initializer
	var authCoordinator: AuthCoordinator?
	lazy var contactsCoordinator = ContactsCoordinator(contactsController: self.contactsController)
	lazy var profileCoordinator = ProfileCoordinator()
	/// property observer (cannot present a view when its parent isn't part of the view hierarchy, so we need to watch
	/// for when the parent is in the hierarchy
	private var windowObserver: NSKeyValueObservation?
	private var credentialObserver: NSObjectProtocol?

	let contactsController = ContactsController()

	init() {
		super.init(nibName: nil, bundle: nil)

		// FIXME: This line is currently here only for debugging. Can be removed.
		contactsCoordinator.tempAuthManager = authManager
		viewControllers = [profileCoordinator.navigationController, contactsCoordinator.navigationController]

		credentialObserver = NotificationCenter.default.addObserver(forName: .swaapCredentialsChanged, object: nil, queue: nil) { [weak self] _ in
			self?.runAuthCoordinator()
		}

		profileCoordinator.start()
		contactsCoordinator.start()
		// weird double optional BS
		guard let windowOpt = UIApplication.shared.delegate?.window else { return }
		guard let window = windowOpt else { return }
		windowObserver = window.observe(\UIWindow.rootViewController, changeHandler: { window, _ in
			if window.rootViewController === self {
				self.runAuthCoordinator()
			}
		})
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init coder not implemented")
	}

	private func runAuthCoordinator() {
		if !authManager.credentialsCheckedFromLastSession {
			authManager.credentialsLoading.wait()
		}
		// check if user is logged in, only run if logged out:
		if authManager.credentials == nil {
			// check to confirm that theres either no presented VC or if there is, it's not the auth screen (prevent multiple auth screen layers)
			guard presentedViewController == nil ||
				(presentedViewController != nil && presentedViewController != authCoordinator?.navigationController)
				else { return }
			let authCoordinator = AuthCoordinator(rootTabBarController: self, authManager: authManager)
			self.authCoordinator = authCoordinator
			authCoordinator.start()
		}
	}
}
