//
//  ContactsViewController.swift
//  swaap
//
//  Created by Michael Redig on 12/17/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit
import CoreData

class ContactsViewController: UIViewController, ProfileAccessor, ContactsAccessor, AuthAccessor {

	var authManager: AuthManager?
	var contactsController: ContactsController?
	var profileController: ProfileController?
	var profileChangedObserver: NSObjectProtocol?

	private let searchController = UISearchController(searchResultsController: nil)
	private let connectedStatusPredicate = NSPredicate(format: "connectionStatus == %i", ContactPendingStatus.connected.rawValue)

	lazy var fetchedResultsController: NSFetchedResultsController<ConnectionContact> = {
		let fetchRequest: NSFetchRequest<ConnectionContact> = ConnectionContact.fetchRequest()
		let nameDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
		fetchRequest.sortDescriptors = [nameDescriptor]
		fetchRequest.predicate = self.connectedStatusPredicate

		let moc = CoreDataStack.shared.mainContext
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
																  managedObjectContext: moc,
																  sectionNameKeyPath: "section",
																  cacheName: nil)
		fetchedResultsController.delegate = self
		do {
			try fetchedResultsController.performFetch()
		} catch {
			print("error performing initial fetch for frc: \(error)")
		}
		return fetchedResultsController
	}()

	lazy var refreshControl: UIRefreshControl = {
		let refreshCtrl = UIRefreshControl()
		refreshCtrl.addTarget(self, action: #selector(refreshCache), for: .valueChanged)
		refreshCtrl.attributedTitle = NSAttributedString(string: " ")
		refreshCtrl.tintColor = .swaapAccentColorOne
		return refreshCtrl
	}()

	@IBOutlet private weak var tableView: UITableView!

	@IBOutlet private weak var headerImageView: UIImageView!
	@IBOutlet private weak var headerLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.sectionIndexColor = .swaapAccentColorOne
		tableView.tableFooterView = UIView()
		tableView.refreshControl = refreshControl

		updateHeader()
		setupNotifications()

		contactsController?.updateContactCache()

		configureSearch()

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: true)
	}

    private func configureSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.tintColor = .swaapAccentColorOne
		searchController.searchBar.placeholder = "Search contacts"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }

	private func updateHeader() {
		guard isViewLoaded else { return }
		headerImageView.layer.cornerRadius = headerImageView.frame.height / 2
		headerLabel.text = profileController?.userProfile?.name ?? "" + " (you!)"
		guard let imageData = profileController?.userProfile?.photoData, let image = UIImage(data: imageData) else {
			headerImageView.image = nil
			return
		}
		headerImageView.image = image
	}

	@objc func refreshCache() {
		self.refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
		profileController?.fetchProfileFromServer(completion: { [weak self] _ in
			self?.contactsController?.updateContactCache(completion: {
				DispatchQueue.main.async {
					self?.tableView.refreshControl?.attributedTitle = NSAttributedString(string: " ")
					self?.tableView.reloadData()
					self?.refreshControl.endRefreshing()
				}
			})
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

	func searchFetchedResults(for searchText: String) {
		defer {
			do {
				try fetchedResultsController.performFetch()
				tableView.reloadData()
			} catch {
				print(error)
			}
		}

		guard searchText.isNotEmpty else {
			fetchedResultsController.fetchRequest.predicate = connectedStatusPredicate
			return
		}

		let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
		let predicate = NSPredicate(format: "name contains[cd] %@", trimmedText)
		let combinedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [connectedStatusPredicate, predicate])
		fetchedResultsController.fetchRequest.predicate = combinedPredicate
	}

	@IBSegueAction func showCurrentUserProfile(_ coder: NSCoder) -> ProfileViewController? {
		let profileVC = ProfileViewController(coder: coder)
		profileVC?.isCurrentUser = true
		profileVC?.userProfile = profileController?.userProfile
		return profileVC
	}

	@IBSegueAction func showContactProfile(_ coder: NSCoder) -> ProfileViewController? {
		guard let indexPath = tableView.indexPathForSelectedRow else { return ProfileViewController(coder: coder) }
		let contact = fetchedResultsController.object(at: indexPath)
		let profileVC = ProfileViewController(coder: coder)
		profileVC?.isCurrentUser = false
		profileVC?.userProfile = contact.contactProfile
		profileVC?.meetingCoordinate = contact.meetingCoordinate
		return profileVC
	}

	@IBAction func moreOptionsButtonTapped(_ sender: UIBarButtonItem) {
		let image = UIImage(systemName: "arrow.uturn.left")
		let optionController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		let logoutSelection = UIAlertAction(title: "Logout", style: .default) { _ in
			let logoutController = UIAlertController(title: "Are you sure you want to logout?", message: nil, preferredStyle: .actionSheet)
			let cancelLogoutAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
			let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
				self.authManager?.clearSession()
			}
			logoutAction.setValue(image, forKey: "image")
			[logoutAction, cancelLogoutAction].forEach { logoutController.addAction($0) }
			self.present(logoutController, animated: true)
		}
		let aboutAction = UIAlertAction(title: "About", style: .default) { _ in
			self.showAbout()
		}
		let tokenAction = UIAlertAction(title: "JWT (for debug)", style: .default) { [weak self] _ in
			guard let accessToken = self?.authManager?.credentials?.accessToken else { return }
			let activityController = UIActivityViewController(activityItems: [accessToken], applicationActivities: nil)
			self?.present(activityController, animated: true)
		}

		logoutSelection.setValue(image, forKey: "image")

		// only show JWT option while debugging or in testflight
		if ReleaseState.current != .appStore {
			optionController.addAction(tokenAction)
		}
		[aboutAction, logoutSelection, cancelAction].forEach { optionController.addAction($0) }
		present(optionController, animated: true)
	}

	private func showAbout() {
		let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
		let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
		let message = """
		swaap was developed as a Labs project by students at Lambda School.

		iOS Developers:
		Michael Redig
		Marlon Raskin

		Web Developers:
		Jonathan Picazzo
		Bobby Hall
		Tyler Quinn
		Jarvise Billups
		Zachary Peasley

		UX Designers:
		Tyler Nishida
		Emily Arias

		Current environment: \(ReleaseState.current == .appStore ? "Production" : "Staging")
		App version: \(appVersion) (\(buildVersion))
		"""
		let aboutController = UIAlertController(title: "About swaap", message: message, preferredStyle: .actionSheet)
		let finishAction = UIAlertAction(title: "Neat!", style: .cancel, handler: nil)
		aboutController.addAction(finishAction)
		present(aboutController, animated: true)
	}
}

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		fetchedResultsController.sections?.count ?? 0
	}

	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		fetchedResultsController.sectionIndexTitles
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

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let contact = fetchedResultsController.object(at: indexPath)
			guard let id = contact.connectionID else { return }
			contactsController?.deleteConnection(toConnectionID: id, completion: { result in
				switch result {
				case .success:
					self.contactsController?.updateContactCache()
				case .failure(let error):
					NSLog("Error cancelling/deleting contact: \(error)")
				}
			})
		}
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		fetchedResultsController.sections?[section].name
	}

	private func contactCell(on tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
		let contact = fetchedResultsController.object(at: indexPath)
		cell.textLabel?.text = contact.name
		return cell
	}

	func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
		let result = fetchedResultsController.section(forSectionIndexTitle: title, at: index)
		return result
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
		guard let sectionLetter = sectionName.first else { return nil }
		return String(sectionLetter).capitalized
	}
}

extension ContactsViewController: UISearchBarDelegate, UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		let searchText = searchController.searchBar.text ?? ""
		searchFetchedResults(for: searchText)
	}
}
