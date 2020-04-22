## ContactsViewController

**internal** *class*

```swift
class ContactsViewController: UIViewController, ProfileAccessor, ContactsAccessor, AuthAccessor
```

No documentation



*Found in:*

* `swaap/View Controllers/ContactsViewController.swift`


### Members



* ##--Property/authManager/authManager--##
	***internal*** *instance property*
	No documentation
	```swift
	var authManager: AuthManager?
	```

* ##--Property/contactsController/contactsController--##
	***internal*** *instance property*
	No documentation
	```swift
	var contactsController: ContactsController?
	```

* ##--Property/profileController/profileController--##
	***internal*** *instance property*
	No documentation
	```swift
	var profileController: ProfileController?
	```

* ##--Property/profileChangedObserver/profileChangedObserver--##
	***internal*** *instance property*
	No documentation
	```swift
	var profileChangedObserver: NSObjectProtocol?
	```

* ##--Property/searchController/searchController--##
	***private*** *instance property*
	No documentation
	```swift
	private let searchController = UISearchController(searchResultsController: nil)
	```

* ##--Property/connectedStatusPredicate/connectedStatusPredicate--##
	***private*** *instance property*
	No documentation
	```swift
	private let connectedStatusPredicate = NSPredicate(format: "connectionStatus == %i", ContactPendingStatus.connected.rawValue)
	```

* ##--Property/fetchedResultsController/fetchedResultsController--##
	***internal*** *instance property*
	No documentation
	```swift
	lazy var fetchedResultsController: NSFetchedResultsController<ConnectionContact>
	```

* ##--Property/refreshControl/refreshControl--##
	***internal*** *instance property*
	No documentation
	```swift
	lazy var refreshControl: UIRefreshControl
	```

* ##--Property/tableView/tableView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var tableView: UITableView!
	```

* ##--Property/headerImageView/headerImageView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var headerImageView: UIImageView!
	```

* ##--Property/headerLabel/headerLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var headerLabel: UILabel!
	```

* ##--Method/viewDidLoad()/viewDidLoad()--##
	***internal*** *instance method*
	No documentation
	```swift
	override func viewDidLoad()
	```

* ##--Method/viewWillAppear(_%3A)/viewWillAppear(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	override func viewWillAppear(_ animated: Bool)
	```

* ##--Method/configureSearch()/configureSearch()--##
	***private*** *instance method*
	No documentation
	```swift
	private func configureSearch()
	```

* ##--Method/updateHeader()/updateHeader()--##
	***private*** *instance method*
	No documentation
	```swift
	private func updateHeader()
	```

* ##--Method/refreshCache()/refreshCache()--##
	***internal*** *instance method*
	No documentation
	```swift
	@objc func refreshCache()
	```

* ##--Method/setupNotifications()/setupNotifications()--##
	***private*** *instance method*
	No documentation
	```swift
	private func setupNotifications()
	```

* ##--Method/searchFetchedResults(for%3A)/searchFetchedResults(for:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func searchFetchedResults(for searchText: String)
	```

* ##--Method/showCurrentUserProfile(_%3A)/showCurrentUserProfile(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBSegueAction func showCurrentUserProfile(_ coder: NSCoder) -> ProfileViewController?
	```

* ##--Method/showContactProfile(_%3A)/showContactProfile(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBSegueAction func showContactProfile(_ coder: NSCoder) -> ProfileViewController?
	```

* ##--Method/moreOptionsButtonTapped(_%3A)/moreOptionsButtonTapped(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func moreOptionsButtonTapped(_ sender: UIBarButtonItem)
	```

* ##--Method/showAbout()/showAbout()--##
	***private*** *instance method*
	No documentation
	```swift
	private func showAbout()
	```

### Extension: ContactsViewController

**internal** *extension*

```swift
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource
```

No documentation




* ##--Method/numberOfSections(in%3A)/numberOfSections(in:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func numberOfSections(in tableView: UITableView) -> Int
	```

* ##--Method/sectionIndexTitles(for%3A)/sectionIndexTitles(for:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func sectionIndexTitles(for tableView: UITableView) -> [String]?
	```

* ##--Method/tableView(_%3AnumberOfRowsInSection%3A)/tableView(_:numberOfRowsInSection:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	```

* ##--Method/tableView(_%3AcellForRowAt%3A)/tableView(_:cellForRowAt:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	```

* ##--Method/tableView(_%3Acommit%3AforRowAt%3A)/tableView(_:commit:forRowAt:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
	```

* ##--Method/tableView(_%3AtitleForHeaderInSection%3A)/tableView(_:titleForHeaderInSection:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
	```

* ##--Method/contactCell(on%3Aat%3A)/contactCell(on:at:)--##
	***private*** *instance method*
	No documentation
	```swift
	private func contactCell(on tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
	```

* ##--Method/tableView(_%3AsectionForSectionIndexTitle%3Aat%3A)/tableView(_:sectionForSectionIndexTitle:at:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
	```

### Extension: ContactsViewController

**internal** *extension*

```swift
extension ContactsViewController: NSFetchedResultsControllerDelegate
```

No documentation




* ##--Method/controllerWillChangeContent(_%3A)/controllerWillChangeContent(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
	```

* ##--Method/controllerDidChangeContent(_%3A)/controllerDidChangeContent(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
	```

* ##--Method/controller(_%3AdidChange%3AatSectionIndex%3Afor%3A)/controller(_:didChange:atSectionIndex:for:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
					didChange sectionInfo: NSFetchedResultsSectionInfo,
					atSectionIndex sectionIndex: Int,
					for type: NSFetchedResultsChangeType)
	```

* ##--Method/controller(_%3AdidChange%3Aat%3Afor%3AnewIndexPath%3A)/controller(_:didChange:at:for:newIndexPath:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
					didChange anObject: Any,
					at indexPath: IndexPath?,
					for type: NSFetchedResultsChangeType,
					newIndexPath: IndexPath?)
	```

* ##--Method/controller(_%3AsectionIndexTitleForSectionName%3A)/controller(_:sectionIndexTitleForSectionName:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String?
	```

### Extension: ContactsViewController

**internal** *extension*

```swift
extension ContactsViewController: UISearchBarDelegate, UISearchResultsUpdating
```

No documentation




* ##--Method/updateSearchResults(for%3A)/updateSearchResults(for:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func updateSearchResults(for searchController: UISearchController)
	```


