//
//  RootTabBarController.swift
//  swaap
//
//  Created by Michael Redig on 11/12/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {
	// top level coordinators go here - they will be passed in as arguments to the initializer
	var authCoordinator: AuthCoordinator?
	lazy var contactsCoordinator = ContactsCoordinator(contactsController: self.contactsController)

	/// property observer (cannot present a view when its parent isn't part of the view hierarchy, so we need to watch
	/// for when the parent is in the hierarchy
	private var windowObserver: NSKeyValueObservation?

	let contactsController = ContactsController()

	init() {
		super.init(nibName: nil, bundle: nil)

		viewControllers = [contactsCoordinator.navigationController]

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
		// check if user is logged in, only run if logged out:
		if true {
			let authCoordinator = AuthCoordinator(rootTabBarController: self)
			self.authCoordinator = authCoordinator
			authCoordinator.start()
		}
	}
}
