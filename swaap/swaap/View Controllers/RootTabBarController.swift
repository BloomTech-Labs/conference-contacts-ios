//
//  RootTabBarController.swift
//  swaap
//
//  Created by Michael Redig on 11/12/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {

	/// property observer (cannot present a view when its parent isn't part of the view hierarchy, so we need to watch
	/// for when the parent is in the hierarchy
	private var windowObserver: NSKeyValueObservation?
	private var populatedCredentialObserver: NSObjectProtocol?
	private var depopulatedCredentialObserver: NSObjectProtocol?

	let authManager: AuthManager
	let profileController: ProfileController
	let contactsController: ContactsController
	lazy var rootAuthVC: RootAuthViewController = {
		let storyboard = UIStoryboard(name: "Login", bundle: nil)
		let rootAuthVC = storyboard.instantiateViewController(identifier: "RootAuthViewController") { coder in
			RootAuthViewController(coder: coder, authManager: self.authManager, profileController: self.profileController)
		}
		return rootAuthVC
	}()

	@available (*, unavailable)
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		fatalError("nib name etc not supported")
	}

	required init?(coder: NSCoder) {
		let authManager = AuthManager()
		self.authManager = authManager
		let profileController = ProfileController(authManager: authManager)
		self.profileController = profileController
		self.contactsController = ContactsController(profileController: profileController)
		super.init(coder: coder)

		updateViewControllers()
	}

	override var viewControllers: [UIViewController]? {
		didSet {
			updateViewControllers()
		}
	}

	private func updateViewControllers() {
		guard let vcs = viewControllers else { return }
		vcs.forEach { ($0 as? AuthAccessor)?.authManager = authManager }

		// FIXME: For debugging
		vcs.forEach { ($0 as? ProfileAccessor)?.profileController = profileController }
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		populatedCredentialObserver = NotificationCenter.default.addObserver(forName: .swaapCredentialsPopulated, object: nil, queue: nil) { [weak self] _ in
			self?.dismissAuthViewController()
		}
		depopulatedCredentialObserver = NotificationCenter.default.addObserver(forName: .swaapCredentialsDepopulated, object: nil, queue: nil) { [weak self] _ in
			self?.showAuthViewController()
		}

		// weird double optional BS
		guard let windowOpt = UIApplication.shared.delegate?.window else { return }
		guard let window = windowOpt else { return }
		windowObserver = window.observe(\UIWindow.rootViewController, changeHandler: { window, _ in
			if window.rootViewController === self {
				self.showAuthViewController()
			}
		})
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		showAuthViewController()
	}

	private func showAuthViewController() {
		// check to confirm that theres either no presented VC or if there is, it's not the auth screen (prevent multiple auth screen layers)
		guard presentedViewController != rootAuthVC else { return }
		if !authManager.credentialsCheckedFromLastSession {
			authManager.credentialsLoading.wait()
		}
		// check if user is logged in, only run if logged out:
		if authManager.credentials == nil {
			rootAuthVC.modalPresentationStyle = .fullScreen
			self.present(rootAuthVC, animated: true, completion: nil)
		}
	}

	private func dismissAuthViewController() {
		guard presentedViewController == rootAuthVC else { return }
		rootAuthVC.dismiss(animated: true)
	}
}
