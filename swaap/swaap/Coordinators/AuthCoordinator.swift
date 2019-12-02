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
	var popRecognizer: InteractivePopRecognizer?

	let authManager: AuthManager

	init(navigationController: UINavigationController = UINavigationController(), rootTabBarController: UITabBarController, authManager: AuthManager) {
		self.navigationController = navigationController
		self.rootTabBarController = rootTabBarController
		self.authManager = authManager
	}

	func start() {
		let storyboard = UIStoryboard(name: "Login", bundle: nil)
		let rootAuthVC = storyboard.instantiateViewController(identifier: "RootAuthViewController") { coder in
			RootAuthViewController(coder: coder, authManager: self.authManager)
		}
		navigationController.pushViewController(rootAuthVC, animated: false)
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
