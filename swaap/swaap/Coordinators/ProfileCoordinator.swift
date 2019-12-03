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
	var popRecognizer: InteractivePopRecognizer?

	init(navigationController: UINavigationController = UINavigationController()) {
		self.navigationController = navigationController
	}

	func start() {
		guard let tempVC = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() as? DummyViewController else { return }
//		tempVC.coordinator = self
//		let profileVC = ProfileViewController.instantiate(storyboardName: "Profile")
//		navigationController.pushViewController(profileVC, animated: false)
		navigationController.pushViewController(tempVC, animated: false)
	}

	func showThing() {
		let profileVC = ProfileViewController.instantiate(storyboardName: "Profile")
		navigationController.pushViewController(profileVC, animated: true)
		fixUINavigationBarHideAndUnhideWhenSwipingBackToPreviousUIViewControllerWhenPoppingTopViewControllerOnNavigationStack()
	}
}
