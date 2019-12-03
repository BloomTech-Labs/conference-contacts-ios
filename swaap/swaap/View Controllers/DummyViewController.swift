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
	var popRecognizer: InteractivePopRecognizer?

	override func viewDidLoad() {
		super.viewDidLoad()
		let image = UIImage(systemName: "person.crop.circle.fill")
		let selectedImage = UIImage(systemName: "person.crop.circle.fill")
		let item = UITabBarItem(title: "Profile", image: image, selectedImage: selectedImage)
		navigationController?.tabBarItem = item
		fixUINavigationBarHideAndUnhideWhenSwipingBackToPreviousUIViewControllerWhenPoppingTopViewControllerOnNavigationStack()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: true)
	}

	@IBAction func buttonPressed(_ sender: UIButton) {

	}
}

extension DummyViewController {
	func fixUINavigationBarHideAndUnhideWhenSwipingBackToPreviousUIViewControllerWhenPoppingTopViewControllerOnNavigationStack() {
		guard let navigationController = self.navigationController else { return }
		popRecognizer = InteractivePopRecognizer(controller: navigationController)
		navigationController.interactivePopGestureRecognizer?.delegate = popRecognizer
	}
}
