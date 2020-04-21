## MeetingLocationView

**internal** *class*

```swift
class MeetingLocationView: IBPreviewControl
```

No documentation



*Found in:*

* `swaap/Views/MeetingLocationView.swift`


### Members



* ##--Property/contentView/contentView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private var contentView: UIView!
	```

* ##--Property/headerLabel/headerLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var headerLabel: UILabel!
	```

* ##--Property/locationLabel/locationLabel--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var locationLabel: UILabel!
	```

* ##--Property/mapView/mapView--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var mapView: MKMapView!
	```

* ##--Property/locationButton/locationButton--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var locationButton: UIButton!
	```

* ##--Property/panButton/panButton--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var panButton: UIButton!
	```

* ##--Property/buttonsContainer/buttonsContainer--##
	***private*** *instance property*
	No documentation
	```swift
	@IBOutlet private weak var buttonsContainer: UIView!
	```

* ##--Property/panImage/panImage--##
	***internal*** *instance property*
	No documentation
	```swift
	let panImage = UIImage(systemName: "hand.draw.fill")
	```

* ##--Property/noPanImage/noPanImage--##
	***internal*** *instance property*
	No documentation
	```swift
	let noPanImage = UIImage(systemName: "hand.draw")
	```

* ##--Property/header/header--##
	***internal*** *instance property*
	No documentation
	```swift
	var header: String
	```

* ##--Property/location/location--##
	***internal*** *instance property*
	No documentation
	```swift
	var location: MeetingCoordinate?
	```

* ##--Property/locationName/locationName--##
	***internal*** *instance property*
	No documentation
	```swift
	var locationName: String?
	```

* ##--Property/isScrollingEnabled/isScrollingEnabled--##
	***internal*** *instance property*
	No documentation
	```swift
	var isScrollingEnabled: Bool = false
	```

* ##--Method/init(frame%3A)/init(frame:)--##
	***internal*** *instance method*
	No documentation
	```swift
	override init(frame: CGRect)
	```

* ##--Method/init(coder%3A)/init(coder:)--##
	***internal*** *instance method*
	No documentation
	```swift
	required init?(coder aDecoder: NSCoder)
	```

* ##--Method/commonInit()/commonInit()--##
	***private*** *instance method*
	No documentation
	```swift
	private func commonInit()
	```

* ##--Method/configureMapView()/configureMapView()--##
	***private*** *instance method*
	No documentation
	```swift
	private func configureMapView()
	```

* ##--Method/centerMapOnLocation()/centerMapOnLocation()--##
	***private*** *instance method*
	No documentation
	```swift
	private func centerMapOnLocation()
	```

* ##--Method/reverseGeocodeForCityname()/reverseGeocodeForCityname()--##
	***internal*** *instance method*
	No documentation
	```swift
	func reverseGeocodeForCityname()
	```

* ##--Method/configureAnnotation()/configureAnnotation()--##
	***private*** *instance method*
	No documentation
	```swift
	private func configureAnnotation()
	```

* ##--Method/toggleMapViewPan(_%3A)/toggleMapViewPan(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func toggleMapViewPan(_ sender: UIButton)
	```

* ##--Method/locateOriginalLocation(_%3A)/locateOriginalLocation(_:)--##
	***internal*** *instance method*
	No documentation
	```swift
	@IBAction func locateOriginalLocation(_ sender: UIButton)
	```

### Extension: MeetingLocationView

**internal** *extension*

```swift
extension MeetingLocationView: MKMapViewDelegate, UIScrollViewDelegate
```

No documentation





