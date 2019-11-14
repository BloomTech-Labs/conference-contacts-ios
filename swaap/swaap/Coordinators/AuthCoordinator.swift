//
//  MainCoordinator.swift
//  swaap
//
//  Created by Michael Redig on 11/12/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class AuthCoordinator: Coordinator, TabBarControllerAccessor {
	var rootTabBarController: UITabBarController
	var childCoordinators: [Coordinator] = []

	var navigationController: UINavigationController

	init(navigationController: UINavigationController = UINavigationController(), rootTabBarController: UITabBarController) {
		self.navigationController = navigationController
		self.rootTabBarController = rootTabBarController
	}

	func start() {
		let tempVC = UIViewController()
		let label = UILabel()
		label.text = "Test"

		tempVC.view.addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.centerYAnchor.constraint(equalTo: tempVC.view.centerYAnchor).isActive = true
		label.centerXAnchor.constraint(equalTo: tempVC.view.centerXAnchor).isActive = true
		navigationController.pushViewController(tempVC, animated: false)
		navigationController.modalPresentationStyle = .fullScreen

		self.rootTabBarController.present(self.navigationController, animated: false)
	}
}

extension AuthCoordinator: SignUp, Login {
	func showSignUpScreen() {

	}

	func showLoginScreen() {

	}
}
