## QRViewController

**internal** *class*

```swift
class QRViewController: UIViewController, ProfileAccessor
```

This is due for a refactor. The best way to do this would be to have the generator render and cache the qr code in
the background, ready to show the image immediately when its ready. The logic flow of this ViewController could use
some refactoring too.



*Found in:*

* `swaap/View Controllers/QRViewController.swift`


### Members



* ##--Property/qrGen/qrGen--##
	***internal*** *instance property*
	No documentation
	```swift
	lazy var qrGen = QRettyCodeImageGenerator(data: self
	```

* ##--Property/profileController/profileController--##
	***internal*** *instance property*
	No documentation
	```swift
	var profileController: ProfileController?
	```

* ##--Property/qrImageView/qrImageView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var qrImageView: UIImageView!
	```

* ##--Property/stagingIndicatorLabel/stagingIndicatorLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var stagingIndicatorLabel: UILabel!
	```

* ##--Property/locationManager/locationManager--##
	***internal*** *instance property*
	No documentation
	```swift
	var locationManager: LocationHandler?
	```

* ##--Method/updateViews()/updateViews()--##
	***private*** *instance method*
	No documentation
	```swift
	private func updateViews()
	```

* ##--Method/viewDidAppear(_%3A)/viewDidAppear(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	override func viewDidAppear(_ animated: Bool)
	```

* ##--Method/viewDidDisappear(_%3A)/viewDidDisappear(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	override func viewDidDisappear(_ animated: Bool)
	```

* ##--Method/viewDidLoad()/viewDidLoad()--##
	***internal*** *instance method*
	No documentation
	```swift
	override func viewDidLoad()
	```


