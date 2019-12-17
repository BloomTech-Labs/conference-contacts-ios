//
//  ContactsViewController.swift
//  swaap
//
//  Created by Michael Redig on 12/17/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, ProfileAccessor {

	var profileController: ProfileController?
	var profileChangedObserver: NSObjectProtocol?

	@IBOutlet private weak var tableView: UITableView!

	@IBOutlet private weak var headerImageView: UIImageView!
	@IBOutlet private weak var headerLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self

		updateHeader()
		setupNotifications()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: true)
	}

	private func updateHeader() {
		headerImageView.layer.cornerRadius = headerImageView.frame.height / 2
		headerLabel.text = profileController?.userProfile?.name ?? "" + " (you!)"
		guard let imageData = profileController?.userProfile?.photoData, let image = UIImage(data: imageData) else {
			headerImageView.image = nil
			return
		}
		headerImageView.image = image
	}

	private func setupNotifications() {
		let updateClosure = { (_: Notification) in
			DispatchQueue.main.async {
				self.updateHeader()
			}
		}
		profileChangedObserver = NotificationCenter.default.addObserver(forName: .userProfileChanged, object: nil, queue: nil, using: updateClosure)
	}

	@IBSegueAction func showCurrentUserProfile(_ coder: NSCoder) -> ProfileViewController? {
		return ProfileViewController(coder: coder)
	}

	@IBSegueAction func showContactProfile(_ coder: NSCoder) -> ProfileViewController? {
		return ProfileViewController(coder: coder)
	}
}

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		default:
			return contactCell(on: tableView, at: indexPath)
		}
	}

	private func contactCell(on tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
		return cell
	}
}
