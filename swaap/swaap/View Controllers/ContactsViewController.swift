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
		headerImageView.layer.cornerRadius = headerImageView.frame.height / 2
		headerLabel.text = profileController?.userProfile?.name ?? "" + " (you!)"
		guard let imageData = profileController?.userProfile?.photoData, let image = UIImage(data: imageData) else {
			headerImageView.image = nil
			return
		}
		headerImageView.image = image
	}

	@objc func refreshCache() {
		refreshControl.beginRefreshing()
		self.refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
		profileController?.fetchProfileFromServer(completion: { [weak self] _ in
			self?.contactsController?.updateContactCache(completion: {
				DispatchQueue.main.async {
					self?.tableView.refreshControl?.attributedTitle = NSAttributedString(string: " ")
					self?.tableView.reloadData()
					self?.refreshControl.endRefreshing()
					self?.tableView.alwaysBounceVertical = true
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
		return profileVC
	}
}

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		fetchedResultsController.sections?.count ?? 1
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

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		guard let letter = fetchedResultsController.sections?[section].name.first else { return "" }
		return String(letter).capitalized
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
