//
//  PurchaseItemCoordinator.swift
//  swaap
//
//  Created by Michael Redig on 11/12/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

protocol Login {
	func showLoginScreen()
}

protocol SignUp {
	func showSignUpScreen()
}

protocol TabBarControllerAccessor {
	var rootTabBarController: UITabBarController { get set }
}
