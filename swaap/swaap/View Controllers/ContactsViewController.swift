//
//  ContactsViewController.swift
//  swaap
//
//  Created by Michael Redig on 12/17/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import CoreData

class ContactsViewController: UIViewController, ProfileAccessor, ContactsAccessor {

	var contactsController: ContactsController?
	var profileController: ProfileController?
	var profileChangedObserver: NSObjectProtocol?

	lazy var fetchedResultsController: NSFetchedResultsController<ConnectionContact> = {
		let fetchRequest: NSFetchRequest<ConnectionContact> = ConnectionContact.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

		let moc = CoreDataStack.shared.mainContext
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
																  managedObjectContext: moc,
																  sectionNameKeyPath: nil,
																  cacheName: nil)
		fetchedResultsController.delegate = self
		do {
			try fetchedResultsController.performFetch()
		} catch {
			print("error performing initial fetch for frc: \(error)")
		}
		return fetchedResultsController
	}()

	@IBOutlet private weak var tableView: UITableView!

	@IBOutlet private weak var headerImageView: UIImageView!
	@IBOutlet private weak var headerLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self

		updateHeader()
		setupNotifications()

		contactsController?.updateContactCache()

		tableView.refreshControl = UIRefreshControl()
		tableView.refreshControl?.addTarget(self, action: #selector(refreshCache), for: .valueChanged)
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

	@objc func refreshCache() {
		tableView.refreshControl?.beginRefreshing()
		contactsController?.updateContactCache(completion: { [weak self] in
			DispatchQueue.main.async {
				self?.tableView.refreshControl?.endRefreshing()
			}
		})
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
		let profileVC = ProfileViewController(coder: coder)
		profileVC?.isCurrentUser = true
		profileVC?.userProfile = profileController?.userProfile
		return profileVC
	}

	@IBSegueAction func showContactProfile(_ coder: NSCoder) -> ProfileViewController? {
		return ProfileViewController(coder: coder)
	}
}

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		fetchedResultsController.sections?.count ?? 0
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		fetchedResultsController.sections?[section].numberOfObjects ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		default:
			return contactCell(on: tableView, at: indexPath)
		}
	}

	private func contactCell(on tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
		let contact = fetchedResultsController.object(at: indexPath)
		cell.textLabel?.text = contact.name
		return cell
	}
}

// MARK: - Fetched Results Controller Delegate
extension ContactsViewController: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
					didChange sectionInfo: NSFetchedResultsSectionInfo,
					atSectionIndex sectionIndex: Int,
					for type: NSFetchedResultsChangeType) {
		let indexSet = IndexSet([sectionIndex])
		switch type {
		case .insert:
			tableView.insertSections(indexSet, with: .automatic)
		case .delete:
			tableView.deleteSections(indexSet, with: .automatic)
		default:
			print(#line, #file, "unexpected NSFetchedResultsChangeType: \(type)")
		}
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
					didChange anObject: Any,
					at indexPath: IndexPath?,
					for type: NSFetchedResultsChangeType,
					newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			guard let newIndexPath = newIndexPath else { return }
			tableView.insertRows(at: [newIndexPath], with: .automatic)
		case .move:
			guard let newIndexPath = newIndexPath, let indexPath = indexPath else { return }
			tableView.moveRow(at: indexPath, to: newIndexPath)
		case .update:
			guard let indexPath = indexPath else { return }
			tableView.reloadRows(at: [indexPath], with: .automatic)
		case .delete:
			guard let indexPath = indexPath else { return }
			tableView.deleteRows(at: [indexPath], with: .automatic)
		@unknown default:
			print(#line, #file, "unknown NSFetchedResultsChangeType: \(type)")
		}
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
		return nil
	}
}
