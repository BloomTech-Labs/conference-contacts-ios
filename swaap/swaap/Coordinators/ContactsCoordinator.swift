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

	let contactsController: ContactsController

	init(navigationController: UINavigationController = UINavigationController(), contactsController: ContactsController) {
		self.navigationController = navigationController
		self.contactsController = contactsController
	}

	func start() {
		let vc = UIViewController()
		navigationController.pushViewController(vc, animated: false)

		let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(testFunc))
		vc.navigationItem.rightBarButtonItem = button
	}

	@objc func testFunc() {
		AuthManager().clearSession()
	}
}

