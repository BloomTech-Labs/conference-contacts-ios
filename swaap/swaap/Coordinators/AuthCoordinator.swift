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
		let storyboard = UIStoryboard(name: "Login", bundle: nil)
		let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
		navigationController.pushViewController(loginVC, animated: false)
		navigationController.modalPresentationStyle = .fullScreen
		navigationController.isNavigationBarHidden = true
		self.rootTabBarController.present(self.navigationController, animated: false)
	}
}

extension AuthCoordinator: SignUp, Login {
	func showSignUpScreen() {

	}

	func showLoginScreen() {

	}
}
