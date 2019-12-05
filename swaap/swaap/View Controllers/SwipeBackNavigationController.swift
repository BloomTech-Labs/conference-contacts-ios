//
//  SwipeBackNavigationController.swift
//  swaap
//
//  Created by Marlon Raskin on 12/3/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class SwipeBackNavigationController: UINavigationController, AuthAccessor {
	var popRecognizer: InteractivePopRecognizer?
	var authManager: AuthManager? {
		didSet {
			distributeAccessor()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		fixUINavigationBarHideAndUnhideWhenSwipingBackToPreviousUIViewControllerWhenPoppingTopViewControllerOnNavigationStack()
	}

	private func fixUINavigationBarHideAndUnhideWhenSwipingBackToPreviousUIViewControllerWhenPoppingTopViewControllerOnNavigationStack() {
		popRecognizer = InteractivePopRecognizer(controller: self)
		interactivePopGestureRecognizer?.delegate = popRecognizer
	}

	private func distributeAccessor() {
		guard let authManager = authManager else { return }
		for case let authAccess as AuthAccessor in viewControllers {
			authAccess.authManager = authManager
		}
	}
}

extension SwipeBackNavigationController: UINavigationControllerDelegate {
	func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
		if let authAccessor = viewController as? AuthAccessor {
			authAccessor.authManager = authManager
		}
	}
}
