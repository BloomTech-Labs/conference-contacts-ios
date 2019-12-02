//
//  ContactsCoordinator.swift
//  swaap
//
//  Created by Michael Redig on 11/12/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class ContactsCoordinator: Coordinator {
	var childCoordinators: [Coordinator] = []
	var navigationController: UINavigationController
	var popRecognizer: InteractivePopRecognizer?

	let contactsController: ContactsController

	// FIXME: This var is currently here only for debugging. Can be removed.
	var tempAuthManager: AuthManager?

	init(navigationController: UINavigationController = UINavigationController(), contactsController: ContactsController) {
		self.navigationController = navigationController
		self.contactsController = contactsController
	}

	func start() {
		// FIXME: This block is currently here only for debugging. Can be removed.
		let vc = UIViewController()
		navigationController.pushViewController(vc, animated: false)

		let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(testFunc))
		vc.navigationItem.rightBarButtonItem = button
		// FIXME: end debug block
	}

	// FIXME: This func is currently here only for debugging. Can be removed.
	@objc func testFunc() {
		tempAuthManager?.clearSession()
	}
}
