//
//  SwipeBackNavigationController.swift
//  swaap
//
//  Created by Marlon Raskin on 12/3/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class SwipeBackNavigationController: UINavigationController, AuthAccessor, ProfileAccessor {
	var popRecognizer: InteractivePopRecognizer?
	var authManager: AuthManager? {
		didSet {
			distributeAuthAccessor()
		}
	}

	var profileController: ProfileController? {
		didSet {
			distributeProfileAccessor()
		}
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	convenience init?(coder decoder: NSCoder, profileController: ProfileController?, authManager: AuthManager? = nil) {
		self.init(coder: decoder)
		self.profileController = profileController
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		delegate = self
		fixUINavigationBarHideAndUnhideWhenSwipingBackToPreviousUIViewControllerWhenPoppingTopViewControllerOnNavigationStack()
	}

	private func fixUINavigationBarHideAndUnhideWhenSwipingBackToPreviousUIViewControllerWhenPoppingTopViewControllerOnNavigationStack() {
		popRecognizer = InteractivePopRecognizer(controller: self)
		interactivePopGestureRecognizer?.delegate = popRecognizer
	}

	private func distributeAuthAccessor() {
		guard let authManager = authManager else { return }
		for case let authAccess as AuthAccessor in viewControllers {
			authAccess.authManager = authManager
		}
	}

	private func distributeProfileAccessor() {
		guard let profileController = profileController else { return }
		for case let profileAccess as ProfileAccessor in viewControllers {
			profileAccess.profileController = profileController
		}
	}
}

extension SwipeBackNavigationController: UINavigationControllerDelegate {
	func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
		if let authAccessor = viewController as? AuthAccessor {
			authAccessor.authManager = authManager
		}
		if let profileAccess = viewController as? ProfileAccessor {
			profileAccess.profileController = profileController
		}
	}
}
