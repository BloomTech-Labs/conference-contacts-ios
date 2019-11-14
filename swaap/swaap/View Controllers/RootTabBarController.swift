//
//  RootTabBarController.swift
//  swaap
//
//  Created by Michael Redig on 11/12/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {
	// top level coordinators go here - they will be passed in as arguments to the initializer
	var authCoordinator: AuthCoordinator?

	init() {
		super.init(nibName: nil, bundle: nil)
		viewControllers = [UIViewController()]
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init coder not implemented")
	}

	override func didMoveToWindow(_ window: UIWindow) {
		if true { // check to see if user is logged in
			runAuthCoordinator()
		}
	}

	private func runAuthCoordinator() {
		let authCoordinator = AuthCoordinator(rootTabBarController: self)
		self.authCoordinator = authCoordinator
		authCoordinator.start()
	}
}
