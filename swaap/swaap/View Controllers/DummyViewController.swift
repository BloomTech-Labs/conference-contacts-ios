//
//  DummyViewController.swift
//  swaap
//
//  Created by Michael Redig on 12/2/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class DummyViewController: UIViewController {

	let authManager = AuthManager()
	var coordinator: ProfileCoordinator?
	var popRecognizer: InteractivePopRecognizer?

	override func viewDidLoad() {
		super.viewDidLoad()

		fixUINavigationBarHideAndUnhideWhenSwipingBackToPreviousUIViewControllerWhenPoppingTopViewControllerOnNavigationStack()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: true)
	}

	@IBAction func buttonPressed(_ sender: UIButton) {
		coordinator?.showThing()
	}

	#warning("Getting error in DummyVC in viewDidLoad. Wondering if I'm not instantiating it right")

}

extension DummyViewController {
	func fixUINavigationBarHideAndUnhideWhenSwipingBackToPreviousUIViewControllerWhenPoppingTopViewControllerOnNavigationStack() {
		guard let navigationController = self.navigationController else { return }
		popRecognizer = InteractivePopRecognizer(controller: navigationController)
		navigationController.interactivePopGestureRecognizer?.delegate = popRecognizer
	}
}
