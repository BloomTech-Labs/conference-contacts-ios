## PendingContactTableViewCell

**internal** *class*

```swift
class PendingContactTableViewCell: UITableViewCell
```

No documentation



*Found in:*

* `swaap/Views/PendingContactTableViewCell.swift`


### Members



* ##--Property/contactImageView/contactImageView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var contactImageView: UIImageView!
	```

* ##--Property/nameLabel/nameLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var nameLabel: UILabel!
	```

* ##--Property/acceptButton/acceptButton--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var acceptButton: UIButton!
	```

* ##--Property/cancelButton/cancelButton--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var cancelButton: UIButton!
	```

* ##--Property/profileController/profileController--##
	***internal*** *instance property*
	No documentation
	```swift
	var profileController: ProfileController?
	```

* ##--Property/connectionContact/connectionContact--##
	***internal*** *instance property*
	No documentation
	```swift
	var connectionContact: ConnectionContact?
	```

* ##--Property/isIncoming/isIncoming--##
	***internal*** *instance property*
	No documentation
	```swift
	var isIncoming: Bool = true
	```

* ##--Property/delegate/delegate--##
	***internal*** *instance property*
	No documentation
	```swift
	weak var delegate: PendingContactTableViewCellDelegate?
	```

* ##--Method/awakeFromNib()/awakeFromNib()--##
	***internal*** *instance method*
	No documentation
	```swift
	override func awakeFromNib()
	```

* ##--Method/configureCellUI()/configureCellUI()--##
	***private*** *instance method*
	No documentation
	```swift
	private func configureCellUI()
	```

* ##--Method/prepareForReuse()/prepareForReuse()--##
	***internal*** *instance method*
	No documentation
	```swift
	override func prepareForReuse()
	```

* ##--Method/updateConstraints()/updateConstraints()--##
	***internal*** *instance method*
	No documentation
	```swift
	override func updateConstraints()
	```

* ##--Method/updateViews()/updateViews()--##
	***private*** *instance method*
	No documentation
	```swift
	private func updateViews()
	```

* ##--Method/enableButtons(_%3A)/enableButtons(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func enableButtons(_ enabled: Bool = true)
	```

* ##--Method/acceptButtonTapped(_%3A)/acceptButtonTapped(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func acceptButtonTapped(_ sender: UIButton)
	```

* ##--Method/cancelButtonTapped(_%3A)/cancelButtonTapped(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func cancelButtonTapped(_ sender: UIButton)
	```


