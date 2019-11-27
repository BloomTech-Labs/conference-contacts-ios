//
//  ProfileCoordinator.swift
//  swaap
//
//  Created by Marlon Raskin on 11/22/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class ProfileCoordinator: Coordinator {
	var childCoordinators: [Coordinator] = []
	var navigationController: UINavigationController

	init(navigationController: UINavigationController = UINavigationController()) {
		self.navigationController = navigationController
	}

	func start() {
		let profileVC = ProfileViewController.instantiate(storyboardName: "Profile")
		navigationController.pushViewController(profileVC, animated: false)
	}
}
