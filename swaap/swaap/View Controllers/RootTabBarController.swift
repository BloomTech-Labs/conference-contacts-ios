//
//  RootTabBarController.swift
//  swaap
//
//  Created by Michael Redig on 11/12/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {
	let authManager = AuthManager()

	/// property observer (cannot present a view when its parent isn't part of the view hierarchy, so we need to watch
	/// for when the parent is in the hierarchy
	private var windowObserver: NSKeyValueObservation?
	private var credentialObserver: NSObjectProtocol?

	let contactsController = ContactsController()
	lazy var rootAuthVC: RootAuthViewController = {
		let storyboard = UIStoryboard(name: "Login", bundle: nil)
		let rootAuthVC = storyboard.instantiateViewController(identifier: "RootAuthViewController") { coder in
			RootAuthViewController(coder: coder, authManager: self.authManager)
		}
		return rootAuthVC
	}()

	override var viewControllers: [UIViewController]? {
		didSet {
			updateViewControllers()
		}
	}

	private func updateViewControllers() {
		guard let vcs = viewControllers else { return }
		vcs.forEach { ($0 as? AuthAccessor)?.authManager = authManager }
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupSecondTab()
		credentialObserver = NotificationCenter.default.addObserver(forName: .swaapCredentialsChanged, object: nil, queue: nil) { [weak self] _ in
			self?.runAuthCoordinator()
		}

		// weird double optional BS
		guard let windowOpt = UIApplication.shared.delegate?.window else { return }
		guard let window = windowOpt else { return }
		windowObserver = window.observe(\UIWindow.rootViewController, changeHandler: { window, _ in
			if window.rootViewController === self {
				self.runAuthCoordinator()
			}
		})
	}

	// FIXME: FOR DEBUGGING
	func setupSecondTab() {
		let vc = UIViewController()
		vc.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
		let doneButton = UIButton(type: .system)
		doneButton.setTitle("done", for: .normal)
		doneButton.addTarget(self, action: #selector(testFunc), for: .touchUpInside)
		vc.view.addSubview(doneButton)
		doneButton.translatesAutoresizingMaskIntoConstraints = false
		doneButton.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
		doneButton.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
		viewControllers?.append(vc)
	}

	// FIXME: FOR DEBUGGING
	@objc func testFunc() {
		authManager.clearSession()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		runAuthCoordinator()
	}

	private func runAuthCoordinator() {
		guard presentedViewController != rootAuthVC else { return }
		if !authManager.credentialsCheckedFromLastSession {
			authManager.credentialsLoading.wait()
		}
		// check if user is logged in, only run if logged out:
		if authManager.credentials == nil {
			// check to confirm that theres either no presented VC or if there is, it's not the auth screen (prevent multiple auth screen layers)
			rootAuthVC.modalPresentationStyle = .fullScreen
			self.present(rootAuthVC, animated: true, completion: nil)
		}
	}
}
