//
//  LocationHandler.swift
//  LambdaTimeline
//
//  Created by Michael Redig on 10/3/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationHandlerDelegate: AnyObject {
	func locationRequester(_ locationRequester: LocationHandler, didUpdateLocation location: CLLocation)
}

class LocationHandler: NSObject {

	private lazy var manager: CLLocationManager = {
		let manager = CLLocationManager()
		manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
		manager.delegate = self
		return manager
	}()

	var lastLocation: CLLocation?
	weak var delegate: LocationHandlerDelegate?

	var isAuthorized: Bool {
		switch CLLocationManager.authorizationStatus() {
		case .authorizedAlways, .authorizedWhenInUse:
			return true
		default:
			return false
		}
	}

	func requestAuth() {
		manager.requestWhenInUseAuthorization()
	}

	func singleLocationRequest() {
		manager.requestLocation()
	}

	func startTrackingLocation() {
		manager.startUpdatingLocation()
	}

	func stopTrackingLocation() {
		manager.stopUpdatingLocation()
	}
}

extension LocationHandler: CLLocationManagerDelegate {

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.first else { return }
		lastLocation = location
		delegate?.locationRequester(self, didUpdateLocation: location)
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Location request failed with error: \(error)")
	}
}
