## LocationHandler

**internal** *class*

```swift
class LocationHandler: NSObject
```

No documentation



*Found in:*

* `swaap/Helpers/LocationHandler.swift`


### Members



* ##--Property/manager/manager--##
	***private*** *instance property*
	No documentation
	```swift
	private lazy var manager: CLLocationManager
	```

* ##--Property/lastLocation/lastLocation--##
	***internal*** *instance property*
	No documentation
	```swift
	var lastLocation: CLLocation?
	```

* ##--Property/delegate/delegate--##
	***internal*** *instance property*
	No documentation
	```swift
	weak var delegate: LocationHandlerDelegate?
	```

* ##--Property/isAuthorized/isAuthorized--##
	***internal*** *instance property*
	No documentation
	```swift
	var isAuthorized: Bool
	```

* ##--Method/requestAuth()/requestAuth()--##
	***internal*** *instance method*
	No documentation
	```swift
	func requestAuth()
	```

* ##--Method/singleLocationRequest()/singleLocationRequest()--##
	***internal*** *instance method*
	No documentation
	```swift
	func singleLocationRequest()
	```

* ##--Method/startTrackingLocation()/startTrackingLocation()--##
	***internal*** *instance method*
	No documentation
	```swift
	func startTrackingLocation()
	```

* ##--Method/stopTrackingLocation()/stopTrackingLocation()--##
	***internal*** *instance method*
	No documentation
	```swift
	func stopTrackingLocation()
	```

### Extension: LocationHandler

**internal** *extension*

```swift
extension LocationHandler: CLLocationManagerDelegate
```

No documentation




* ##--Method/locationManager(_%3AdidUpdateLocations%3A)/locationManager(_:didUpdateLocations:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
	```

* ##--Method/locationManager(_%3AdidFailWithError%3A)/locationManager(_:didFailWithError:)--##
	***internal*** *instance method*
	No documentation
	```swift
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
	```


