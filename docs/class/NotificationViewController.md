## NotificationViewController

**internal** *class*

```swift
class NotificationViewController: UIViewController, ProfileAccessor, ContactsAccessor
```

Name says it.



*Found in:*

* `swaap/View Controllers/NotificationViewController.swift`


### Members



* ##--Property/profileController/profileController--##
	***internal*** *instance property*
	No documentation
	```swift
	var profileController: ProfileController?
	```

* ##--Property/contactsController/contactsController--##
	***internal*** *instance property*
	No documentation
	```swift
	var contactsController: ContactsController?
	```

* ##--Property/tableView/tableView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var tableView: UITableView!
	```

* ##--Property/notificationLabel/notificationLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var notificationLabel: UILabel!
	```

* ##--Property/pushNotificationTimer/pushNotificationTimer--##
	***internal*** *instance property*
	'"push" notification timer - just refreshses frequently to give the appearance that there are push notifications to notifiy you when you get a request
	```swift
	var pushNotificationTimer: Timer?
	```

* ##--Property/fetchedResultsController/fetchedResultsController--##
	***internal*** *instance property*
	No documentation
	```swift
	lazy var fetchedResultsController: NSFetchedResultsController<ConnectionContact>
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

* ##--Method/viewWillDisappear(_%3A)/viewWillDisappear(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	override func viewWillDisappear(_ animated: Bool)
	```

### Extension: NotificationViewController

**internal** *extension*

```swift
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource
```

No documentation




* ##--Method/showHideNotificationLabel()/showHideNotificationLabel()--##
	***fileprivate*** *instance method*
	No documentation
	```swift
	fileprivate func showHideNotificationLabel()
	```

* ##--Method/numberOfSections(in%3A)/numberOfSections(in:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func numberOfSections(in tableView: UITableView) -> Int
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

* ##--Method/tableView(_%3AtitleForHeaderInSection%3A)/tableView(_:titleForHeaderInSection:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
	```

### Extension: NotificationViewController

**internal** *extension*

```swift
extension NotificationViewController: NSFetchedResultsControllerDelegate
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

### Extension: NotificationViewController

**internal** *extension*

```swift
extension NotificationViewController: PendingContactsUpdateDelegate
```

No documentation




* ##--Method/pendingContactsDidRefresh()/pendingContactsDidRefresh()--##
	***internal*** *instance method*
	No documentation
	```swift
	func pendingContactsDidRefresh()
	```

### Extension: NotificationViewController

**internal** *extension*

```swift
extension NotificationViewController: PendingContactTableViewCellDelegate
```

No documentation




* ##--Method/pendingContactRequestAccepted(on%3Acontact%3A)/pendingContactRequestAccepted(on:contact:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func pendingContactRequestAccepted(on cell: PendingContactTableViewCell, contact: ConnectionContact)
	```

* ##--Method/pendingContactRequestCancelled(on%3Acontact%3A)/pendingContactRequestCancelled(on:contact:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func pendingContactRequestCancelled(on cell: PendingContactTableViewCell, contact: ConnectionContact)
	```


