//
//  DummyViewController.swift
//  swaap
//
//  Created by Michael Redig on 12/2/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

// FIXME: FOR DEBUGGING
class DummyViewController: UIViewController {

	let authManager = AuthManager()

	override func viewDidLoad() {
		super.viewDidLoad()
		let image = UIImage(systemName: "person.crop.circle.fill")
		let selectedImage = UIImage(systemName: "person.crop.circle.fill")
		let item = UITabBarItem(title: "Profile", image: image, selectedImage: selectedImage)
		navigationController?.tabBarItem = item
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: true)
	}

	@IBAction func buttonPressed(_ sender: UIButton) {

	}
}
