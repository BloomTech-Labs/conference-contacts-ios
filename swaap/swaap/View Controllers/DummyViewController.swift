//
//  DummyViewController.swift
//  swaap
//
//  Created by Michael Redig on 12/2/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

// FIXME: FOR DEBUGGING
class DummyViewController: UIViewController, AuthAccessor, ProfileAccessor {

	var authManager: AuthManager?
	var profileController: ProfileController?

	override func viewDidLoad() {
		super.viewDidLoad()
		let image = UIImage(systemName: "person.crop.circle.fill")
		let selectedImage = UIImage(systemName: "person.crop.circle.fill")
		let item = UITabBarItem(title: "Profile", image: image, selectedImage: selectedImage)
		navigationController?.tabBarItem = item

		let logoutButton = UIButton(type: .system)
		logoutButton.setTitle("Logout", for: .normal)
		view.addSubview(logoutButton)
		logoutButton.translatesAutoresizingMaskIntoConstraints = false
		logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

		logoutButton.addTarget(self, action: #selector(logoutPressed(_:)), for: .touchUpInside)

		_ = NotificationCenter.default.addObserver(forName: .userProfilePopulated, object: nil, queue: nil) { _ in
			print("populated: \(self.profileController?.userProfile as Any)")
		}
		_ = NotificationCenter.default.addObserver(forName: .userProfileChanged, object: nil, queue: nil) { _ in
			print("changed: \(self.profileController?.userProfile as Any)")
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: true)
	}

	@IBAction func buttonPressed(_ sender: UIButton) {
		if let id = authManager?.credentials?.idToken {
			print("id: '\(id)'")
		}

		if let access = authManager?.credentials?.accessToken {
			print("access: '\(access)'")
		}
	}

	@objc func logoutPressed(_ sender: UIButton) {
		authManager?.clearSession()
	}
}
